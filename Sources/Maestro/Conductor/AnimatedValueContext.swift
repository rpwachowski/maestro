import SwiftUI

/// Adopters of the `AnimatedValueContext` protocol provide functionality for accessing the current value of an animated value.
public protocol AnimatedValueContext {
    subscript<Key: AnimationKey>(_ key: Key.Type) -> Key.Value { get }
}

extension EnvironmentValues {

    private struct NonAnimatedContext: AnimatedValueContext {

        subscript<Key: AnimationKey>(key: Key.Type) -> Key.Value {
            key.defaultValue
        }

    }

    private enum AnimatedValueContextKey: EnvironmentKey {

        static var defaultValue: AnimatedValueContext {
            NonAnimatedContext()
        }

    }

    /// Returns the current animation context.
    ///
    /// If no animation context is set in the parent hierarchy, the context will supply the default values for all keys.
    public internal(set) var animationContext: AnimatedValueContext {
        get { self[AnimatedValueContextKey.self] }
        set { self[AnimatedValueContextKey.self] = newValue }
    }

}
