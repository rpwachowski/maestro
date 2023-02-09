import Foundation

/// A type which interpolates between an initial and target value according to a given ``Blend`` factor.
public protocol Interpolator<Value> {
    associatedtype Value

    /// Returns a value interpolated at the argument ``Blend``.
    func value(at t: Blend, from initialValue: Value, to targetValue: Value) -> Value

}

/// An ``Interpolator`` which interpolates to its specified ``targetValue``.
public protocol KeyframedInterpolator<Value>: Interpolator {
    associatedtype Value

    var targetValue: Value { get }

    func value(at t: Blend, from initialValue: Value) -> Value

}

public extension KeyframedInterpolator {

    func value(at t: Blend, from initialValue: Value, to targetValue: Value) -> Value {
        value(at: t, from: initialValue)
    }

}
