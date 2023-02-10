import Foundation

public extension Interpolator {

    /// Returns an interpolator which applies the given ``TimingFunction`` to the blend argument of the base interpolation.
    func timing(_ timingFunction: any TimingFunction) -> some Interpolator<Value> {
        TimeBlendedInterpolator(interpolator: self, timingFunction: timingFunction)
    }

}

public extension KeyframedInterpolator {

    /// Returns an interpolator which applies the given ``TimingFunction`` to the blend argument of the base interpolation.
    func timing(_ timingFunction: any TimingFunction) -> some KeyframedInterpolator<Value> {
        TimeBlendedKeyframedInterpolator(interpolator: self, timingFunction: timingFunction)
    }

}

struct TimeBlendedInterpolator<Value>: Interpolator {

    var interpolator: any Interpolator<Value>
    var timingFunction: any TimingFunction

    func value(at t: Blend, from initialValue: Value, to targetValue: Value) -> Value {
        interpolator.value(at: timingFunction.value(at: t), from: initialValue, to: targetValue)
    }

}


struct TimeBlendedKeyframedInterpolator<Value>: KeyframedInterpolator {

    var interpolator: any KeyframedInterpolator<Value>
    var timingFunction: any TimingFunction

    var targetValue: Value {
        interpolator.targetValue
    }

    func value(at t: Blend, from initialValue: Value) -> Value {
        interpolator.value(at: timingFunction.value(at: t), from: initialValue)
    }

}
