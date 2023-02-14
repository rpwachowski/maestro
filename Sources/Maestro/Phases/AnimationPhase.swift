import Foundation

public protocol AnimationPhase {
    typealias Duration = AnimationPhaseDuration

    /// The duration of the animation.
    var duration: Duration { get }

    /// Returns a function for computing the value of the supplied `AnimationKey` at the normalized phase time `t`.
    subscript<Key: AnimationKey>(key: Key.Type, at t: Double) -> TransitionFunction<Key.Value>? { get }

}

/// Represents a transition as a function of some initial value.
///
/// You can combine transition functions to create a series of chained transitions.
public struct TransitionFunction<Value> {

    static func + (lhs: Self, rhs: Self) -> Self {
        TransitionFunction(isInstantaneous: lhs.isInstantaneous && rhs.isInstantaneous) { initialValue in
            rhs(initialValue: lhs(initialValue: initialValue))
        }
    }

    // TODO: upgrade AnimationPhase to receive (t, direction)
    var isInstantaneous: Bool

    var function: (Value) -> Value

    /// Returns the transitioned value using the supplied initial value.
    public func callAsFunction(initialValue: Value) -> Value {
        function(initialValue)
    }

}
