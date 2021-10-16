import SwiftUI

public protocol AnimationKey {
    associatedtype Value

    /// The default value for the key.
    ///
    /// This value is used if a conductor has not yet performed a transition over the value and was not provided an initial value.
    static var defaultValue: Value { get }

}

public extension AnimationKey where Value: Numeric {

    static var defaultValue: Value { .zero }

}

public extension AnimationKey {

    /// Creates an initial value for the key.
    static func start(with value: Value) -> AnimationState.Property {
        .init(self, value)
    }

}
