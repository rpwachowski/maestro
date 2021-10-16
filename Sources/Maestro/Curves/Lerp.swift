import Foundation

struct Lerp: Interpolator {
    func value(@Clamped(0, 1) at t: Double) -> Double { t }
}
