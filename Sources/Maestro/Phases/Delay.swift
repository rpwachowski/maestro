import Foundation

/// Delays changes by the specified amount of time.
///
/// You can use this where no changes should occur to insert static periods in an animation scope .
public struct Delay: AnimationPhase {

    public var duration: AnimationPhaseDuration

    public init(duration: TimeInterval) {
        self.duration = .timed(duration)
    }

    public subscript<Key: AnimationKey>(key: Key.Type, at t: Double) -> TransitionFunction<Key.Value>? { nil }

}

public extension AnimationPhase {

    /// Delays the phase by the given amount of time.
    ///
    /// This is equivalent to wrapping the phase in a `AnimateSequentially` with a `Delay` which is first in the sequence.
    func delayed(by delay: TimeInterval) -> AnimationPhase {
        AnimateSequentially {
            Delay(duration: delay)
            self
        }
    }

}
