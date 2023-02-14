import Foundation
import SwiftUI

/// Establishes a keyframe towards which a value may be interpolated.
public struct Animate<Key: AnimationKey>: AnimationPhase {
    private typealias Value = Key.Value

    public var value: Key.Value
    public var interpolator: any Interpolator
    public var duration: AnimationPhaseDuration
    private var interpolation: (Value, Blend) -> Value

    private var keyType: Key.Type {
        Key.self
    }

    public init<Interpolation: Interpolator>(to value: Key.Value, using interpolator: Interpolation, duration: TimeInterval) where Interpolation.Value == Key.Value {
        self.value = value
        self.interpolator = interpolator
        self.duration = .timed(duration)
        self.interpolation = { initialValue, blend in
            interpolator.value(at: blend, from: initialValue, to: value)
        }
    }

    public init<Interpolation: KeyframedInterpolator>(using interpolator: Interpolation, duration: TimeInterval) where Interpolation.Value == Key.Value {
        self.value = interpolator.targetValue
        self.interpolator = interpolator
        self.duration = .timed(duration)
        self.interpolation = { initialValue, blend in
            interpolator.value(at: blend, from: initialValue)
        }
    }

    public init<Timing: TimingFunction>(to value: Key.Value, using timingFunction: Timing = .linear, duration: TimeInterval) where Key.Value: VectorArithmetic {
        self.value = value
        self.interpolator = timingFunction
        self.duration = .timed(duration)
        self.interpolation = { initialValue, blend in
            value.scaled(by: timingFunction.value(at: blend).value) + initialValue.scaled(by: timingFunction.value(at: 1 - blend).value)
        }
    }

    public subscript<Key: AnimationKey>(key: Key.Type, at t: Double) -> TransitionFunction<Key.Value>? {
        guard key == keyType else { return nil }
        return TransitionFunction(isInstantaneous: duration == .instantaneous) { initialValue in
            (initialValue as? Value).map { interpolation($0, Blend(t)) } as? Key.Value ?? initialValue
        }
    }

}
