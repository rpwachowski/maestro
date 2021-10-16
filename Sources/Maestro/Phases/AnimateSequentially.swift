import Foundation
import SwiftUI

/// Performs a series of animations in sequence.
///
/// The duration of the sequential animation is equivalent to the sum of the durations of its constituent animations.
public struct AnimateSequentially: AnimationPhase {

    private var phases: [AnimationPhase]

    public var duration: AnimationPhaseDuration {
        if phases.allSatisfy({ $0.duration == .instantaneous }) { return .instantaneous }
        return .timed(phases.map(\.duration.duration).reduce(0, +))
    }

    public init(@AnimationBuilder phases: () -> [AnimationPhase]) {
        self.phases = phases()
    }

    public subscript<Key: AnimationKey>(key: Key.Type, at t: Double) -> TransitionFunction<Key.Value>? {
        let elapsedTime = duration.duration * t
        var checkedTime = TimeInterval(0)
        var composedFunction: TransitionFunction<Key.Value>?
        for phase in phases {
            guard case .timed(let duration) = phase.duration else {
                if let function = phase[key, at: 0] { composedFunction = function }
                continue
            }
            if checkedTime + duration > elapsedTime {
                let t = (elapsedTime - checkedTime) / duration
                if let function = phase[key, at: t] {
                    composedFunction = composedFunction.map { $0 + function } ?? function
                }
                break
            }
            if let function = phase[key, at: 1] { composedFunction = function }
            checkedTime += duration
        }
        return composedFunction
    }

}
