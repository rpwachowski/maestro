import Maestro

public struct Trail<Key: AnimationKey>: AnimationPhase where Key.Value: VectorArithmetic {

    private var animation: AnimationPhase

    public var duration: Duration {
        animation.duration
    }

    init(in inValue: Key.Value, out outValue: Key.Value, curve: AnimationCurve = .linear, duration: TimeInterval, spacing: TimeInterval) {
        animation = AnimateSequentially {
            Animate<Key>(to: inValue, curve: curve, duration: duration)
            Delay(duration: spacing)
            Animate<Key>(to: outValue, curve: curve, duration: duration)
        }
    }

    public subscript<Key: AnimationKey>(key: Key.Type, at t: Double) -> TransitionFunction<Key.Value>? {
        animation[key, at: t]
    }

}

public struct Staggered: AnimationPhase {

    private var animation: AnimationPhase

    public var duration: Duration {
        animation.duration
    }

    init(by stagger: TimeInterval, @AnimationBuilder animations: () -> [AnimationPhase]) {
        animation = AnimateConcurrently(phases: animations().enumerated().map {
            $0.element.delayed(by: TimeInterval($0.offset) * stagger)
        })
    }

    public subscript<Key: AnimationKey>(key: Key.Type, at t: Double) -> TransitionFunction<Key.Value>? {
        animation[key, at: t]
    }

}
