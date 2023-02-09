import Foundation

/// A type-erased ``Interpolator``.
public struct AnyInterpolator<Value>: Interpolator {

    private var interpolate: (Blend, Value, Value) -> Value

    public init<Base: Interpolator>(_ base: Base) where Base.Value == Value {
        interpolate = base.value(at:from:to:)
    }

    public func value(at t: Blend, from initialValue: Value, to targetValue: Value) -> Value {
        interpolate(t, initialValue, targetValue)
    }

}
