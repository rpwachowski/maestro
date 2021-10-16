import Foundation

/// Performs a series of animations at the same time.
///
/// The duration of the concurrent animation is equivalent to the longest duration of its constituent animations.
public struct AnimateConcurrently: AnimationPhase {

    private var phases: [AnimationPhase]

    public var duration: AnimationPhaseDuration {
        if phases.allSatisfy({ $0.duration == .instantaneous }) { return .instantaneous }
        return .timed(phases.max { $0.duration.duration < $1.duration.duration }?.duration.duration ?? 0)
    }

    public init(phases: [AnimationPhase]) {
        self.phases = phases
    }

    public init(@AnimationBuilder phases: () -> [AnimationPhase]) {
        self.phases = phases()
    }

    public subscript<Key: AnimationKey>(key: Key.Type, at t: Double) -> TransitionFunction<Key.Value>? {
        let time = duration.duration * t
        for phase in phases {
            let tprime = phase.duration == .instantaneous ? 0 : min(time / phase.duration.duration, 1)
            if let function = phase[key, at: tprime] { return function }
        }
        return nil
    }

}
