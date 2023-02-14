import Foundation

/// Instantaneously jumps to a value without animating.
///
/// You can combine conducted animations with view tree animations by using `Jump` as a stand-in for
/// `@State` properties which track an implicit animation. In some cases, view tree animations are necessary
/// since not all animations can be conducted; for example, physics-based spring animations cannot be represented
/// by simple timing functions. 
public struct Jump<Key: AnimationKey>: AnimationPhase {

    public var duration: AnimationPhaseDuration {
        .instantaneous
    }

    public var value: Key.Value

    private var keyType: Key.Type {
        Key.self
    }

    public init(to value: Key.Value) {
        self.value = value
    }

    public subscript<Key: AnimationKey>(key: Key.Type, at t: Double) -> TransitionFunction<Key.Value>? {
        guard keyType == key, let value = self.value as? Key.Value else { return nil }
        return TransitionFunction(isInstantaneous: true) { _ in value }
    }

}
