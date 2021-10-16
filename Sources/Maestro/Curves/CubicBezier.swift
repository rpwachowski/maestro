import SwiftUI

struct CubicBezier: Interpolator {

    private var timingFunction: CAMediaTimingFunction

    init(c0x: Double, c0y: Double, c1x: Double, c1y: Double) {
        timingFunction = CAMediaTimingFunction(controlPoints: Float(c0x), Float(c0y), Float(c1x), Float(c1y))
    }

    func value(@Clamped(0, 1) at t: Double) -> Double {
        timingFunction.value(at: t)
    }

}
