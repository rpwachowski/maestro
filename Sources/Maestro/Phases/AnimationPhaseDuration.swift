import Foundation

public enum AnimationPhaseDuration: Hashable {

    /// The phase occurs immediately; changes are discrete.
    case instantaneous

    /// The phase occurs over time; changes are continuous.
    case timed(TimeInterval)

    var duration: TimeInterval {
        switch self {
        case .instantaneous: return 0
        case .timed(let duration): return duration
        }
    }

}
