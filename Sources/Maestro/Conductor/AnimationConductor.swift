import Foundation

/// A type that represents a complex sequence of animations.
///
/// Animations are defined with a body describing the phases during which values are interpolated and, optionally, the initial state of the animation:
/// ```
/// @State private var conductor = AnimationConductor([.concurrent, .autoreverse, .`repeat`(.forever)]) {
///     TrimPathEnd.start(with: 0.2)
/// } animation: {
///     Animate<TrimPathEnd>(to: 1, curve: .easeInOut, duration: 0.75)
///     Animate<TrimPathStart>(to: 0.8, curve: .easeInOut, duration: 0.5)
///         .delayed(by: 0.5)
/// }
/// ```
public struct AnimationConductor {

    enum RootAnimation: Equatable {
        typealias Generator = (() -> [AnimationPhase]) -> AnimationPhase

        case concurrent
        case sequential

        var generator: Generator {
            self == .concurrent ? AnimateConcurrently.init : AnimateSequentially.init
        }

    }

    struct PlaybackReferenceTime {
        var time = Date()
        @Clamped(0, 1) var t: Double = 0
    }

    // This is functionally equivalent to a concurrent collection of jump animations. Conductors use this
    // to blend the initial state into subsequent animations.
    private struct Initialization: AnimationPhase {

        private var state: AnimationState

        var duration: Duration {
            .instantaneous
        }

        init(from state: AnimationState) {
            self.state = state
        }

        subscript<Key: AnimationKey>(key: Key.Type, at t: Double) -> TransitionFunction<Key.Value>? {
            TransitionFunction { _ in state[key] }
        }

    }

    /// Reports whether the animation is running.
    public private(set) var isRunning = false
    private var initialState: AnimationState
    private var animation: AnimationPhase
    private var options: Options
    private var referenceTime = PlaybackReferenceTime()

    var beginsPaused: Bool {
        options.beginsPaused
    }

    public init(_ options: Options = [.sequential], delay: TimeInterval = 0, @AnimationStateBuilder initialState: () -> [AnimationState.Property], @AnimationBuilder animation phases: () -> [AnimationPhase]) {
        self.init(options, delay: delay, initialState: AnimationState(values: initialState), animation: phases)
    }

    public init(_ options: Options = [.sequential], delay: TimeInterval = 0, initialState: AnimationState = AnimationState(), @AnimationBuilder animation phases: () -> [AnimationPhase]) {
        self.options = options
        self.initialState = initialState
        let addDelay: (AnimationPhase) -> AnimationPhase = delay > 0 ? { $0.delayed(by: delay) } : { $0 }
        animation = AnimateSequentially {
            Initialization(from: initialState)
            addDelay(options.rootAnimation(containing: phases))
        }
    }

    /// Starts the animation.
    ///
    /// - Parameters:
    ///   - time: the reference time for starting the animation. Defaults to the current time.
    public mutating func start(at time: Date = Date()) {
        if isRunning { return }
        referenceTime = PlaybackReferenceTime(time: time, t: referenceTime.t)
        isRunning = true
    }

    /// Pauses the animation.
    ///
    /// - Parameters:
    ///   - time: the reference time for starting the animation. Defaults to the current time.
    public mutating func pause(at time: Date = Date()) {
        if !isRunning { return }
        let t = options.t(referenceTime: referenceTime, currentTime: time, animationCycle: animation.duration.duration)
        referenceTime = PlaybackReferenceTime(time: time, t: t)
        isRunning = false
    }

    /// Returns the interpolated value for the supplied `AnimationKey` calculated from the animation's start time and the given time.
    public subscript<Key: AnimationKey>(_ key: Key.Type, at time: Date) -> Key.Value {
        let t = isRunning ? options.t(referenceTime: referenceTime, currentTime: time, animationCycle: animation.duration.duration) : referenceTime.t
        return animation[key, at: t]?(initialValue: initialState[key]) ?? initialState[key]
    }

}
