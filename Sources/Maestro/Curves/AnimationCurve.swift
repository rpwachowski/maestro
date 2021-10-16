import Foundation
import Maestro_ObjC

public struct AnimationCurve: Hashable {

    public static var linear: Self {
        self.init(Lerp())
    }

    public static var easeInOut: Self {
        cubicBezier(0.5, 0, 0.5, 1)
    }

    public static var easeOut: Self {
        cubicBezier(0, 0, 0.5, 1)
    }

    public static func cubicBezier(@Clamped(0, 1) _ c0x: Double, @Clamped(0, 1) _ c0y: Double, @Clamped(0, 1) _ c1x: Double, @Clamped(0, 1) _ c1y: Double) -> Self {
        self.init(CubicBezier(c0x: c0x, c0y: c0y, c1x: c1x, c1y: c1y))
    }

    private var interpolator: AnyInterpolator

    private init<Base: Interpolator>(_ base: Base) {
        self.interpolator = AnyInterpolator(base)
    }

    public func value(@Clamped(0, 1) at t: Double) -> Double {
        interpolator.value(at: t)
    }

}

extension CAMediaTimingFunction {

    func value(at t: Double) -> Double {
        Double(_solve(forInput: Float(t)))
    }

}
