import Foundation
import UIKit

public enum TimingFunctions {

    public struct Linear: Interpolator {
        public func value(at t: Blend) -> Blend { t }
    }

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
