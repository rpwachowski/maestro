import Foundation

protocol Interpolator: Hashable {
    func value(at t: Double) -> Double
}

struct AnyInterpolator: Interpolator {

    static func == (lhs: AnyInterpolator, rhs: AnyInterpolator) -> Bool {
        lhs.base == rhs.base
    }

    private var base: AnyHashable
    private var interpolate: (Double) -> Double

    init<Base: Interpolator>(_ base: Base) {
        self.base = AnyHashable(base)
        interpolate = base.value(at:)
    }

    func hash(into hasher: inout Hasher) {
        base.hash(into: &hasher)
    }

    func value(@Clamped(0, 1) at t: Double) -> Double {
        interpolate(t)
    }

}
