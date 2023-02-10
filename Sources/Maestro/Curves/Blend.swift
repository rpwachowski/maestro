import Foundation

/// A floating-point value representing the normalized amount by which an ``Interpolator`` blends between initial and target values.
///
/// Initialzing a `Blend` normalizes its representation by clamping it to the interval _[0, 1]_.
public struct Blend: ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {

    public static var zero: Self {
        Blend(0)
    }

    public static func - (lhs: Blend, rhs: Blend) -> Blend {
        Blend(lhs.value - rhs.value)
    }

    public static func * (lhs: Blend, rhs: Blend) -> Blend {
        Blend(lhs.value * rhs.value)
    }

    public static func * (lhs: Blend, rhs: Float) -> Double {
        lhs.value * Double(rhs)
    }

    public static func * (lhs: Blend, rhs: Double) -> Double {
        lhs.value * rhs
    }

    public static func * (lhs: Blend, rhs: CGFloat) -> Double {
        lhs.value * Double(rhs)
    }

    public var value: Double

    public init(@Clamped(0, 1) _ integer: Int) {
        value = Double(integer)
    }

    public init(@Clamped(0, 1) _ float: Float) {
        value = Double(float)
    }

    public init(@Clamped(0, 1) _ double: Double) {
        value = double
    }

    public init(@Clamped(0, 1) floatLiteral value: Double) {
        self.value = value
    }

    public init(@Clamped(0, 1) integerLiteral value: Int) {
        self.value = Double(value)
    }

}
