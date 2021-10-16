import Foundation
import SwiftUI

/// Establishes a keyframe with which a value can be interpolated.
public struct Animate<Key: AnimationKey>: AnimationPhase where Key.Value: VectorArithmetic {
    private typealias Value = Key.Value

    public var value: Key.Value
    public var curve: AnimationCurve
    public var duration: Duration

    private var keyType: Key.Type {
        Key.self
    }

    public init(to value: Key.Value, curve: AnimationCurve = .linear, duration: TimeInterval) {
        self.value = value
        self.curve = curve
        self.duration = .timed(duration)
    }

    public subscript<Key: AnimationKey>(key: Key.Type, at t: Double) -> TransitionFunction<Key.Value>? {
        guard key == keyType else { return nil }
        return TransitionFunction { initialValue in

            (initialValue as? Value).map { value.scaled(by: curve.value(at: t)) + $0.scaled(by: curve.value(at: 1 - t)) } as? Key.Value ?? initialValue
        }
    }

}
