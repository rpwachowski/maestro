import Foundation

/// A type-erased ``Interpolator``.
public struct AnyInterpolator<Value>: Interpolator {

    public static func == (lhs: AnyInterpolator, rhs: AnyInterpolator) -> Bool {
        lhs.base == rhs.base
    }

    private var base: AnyHashable
    private var interpolate: (Blend) -> Value

    public init<Base: Interpolator>(_ base: Base) where Base.Value == Value {
        self.base = AnyHashable(base)
        interpolate = base.value(at:)
    }

    public func hash(into hasher: inout Hasher) {
        base.hash(into: &hasher)
    }

    public func value(at t: Blend) -> Value {
        interpolate(t)
    }

}
