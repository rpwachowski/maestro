import Foundation
import UIKit

/// A namespace of basic timing functions.
public enum TimingFunctions {

    /// A ``TimingFunction`` which does not modify a value's rate of change.
    public struct Linear: Interpolator {
        public func value(at t: Blend) -> Blend { t }
    }

    /// A ``TimingFunction`` which modifies a value's rate of change according to the slope of a cubic Bézier curve.
    ///
    /// - seealso:asdasd https://cubic-bezier.com
    public struct CubicBezier: Interpolator {

        private var timingFunction: CAMediaTimingFunction

        public init(c0x: Double, c0y: Double, c1x: Double, c1y: Double) {
            timingFunction = CAMediaTimingFunction(controlPoints: Float(c0x), Float(c0y), Float(c1x), Float(c1y))
        }

        public func value(at t: Blend) -> Blend {
            Blend(timingFunction.value(at: t.value))
        }

    }

}

public extension Interpolator where Self == TimingFunctions.Linear {

    /// A ``TimingFunction`` which does not modify a value's rate of change.
    static var linear: Self {
        .init()
    }

}

public extension Interpolator where Self == TimingFunctions.CubicBezier {

    /// A ``TimingFunctions/CubicBezier`` timing function which begins slowly and accelerates towards completion.
    static var easeIn: Self {
        .init(c0x: 0.5, c0y: 0, c1x: 1, c1y: 1)
    }

    /// A ``TimingFunctions/CubicBezier`` timing function which begins quickly and decelerates towards completion.
    static var easeOut: Self {
        .init(c0x: 0, c0y: 0, c1x: 0.5, c1y: 1)
    }

    /// A ``TimingFunctions/CubicBezier`` timing function which begins slowly, accelerates through the middle of the transition, and decelerates towards completion.
    static var easeInOut: Self {
        .init(c0x: 0.5, c0y: 0, c1x: 0.5, c1y: 1)
    }

}
