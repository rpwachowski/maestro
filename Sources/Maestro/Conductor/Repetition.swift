import Foundation

public extension AnimationConductor {

    struct Repetition: ExpressibleByIntegerLiteral, Equatable {

        static func + (lhs: AnimationConductor.Repetition, rhs: AnimationConductor.Repetition) -> AnimationConductor.Repetition {
            switch (lhs, rhs) {
            case (_, .forever), (.forever, _): return .forever
            default: return Repetition(count: lhs.count + rhs.count)
            }
        }

        static func < (lhs: Int, rhs: AnimationConductor.Repetition) -> Bool {
            rhs.count.isInfinite || lhs < Int(rhs.count)
        }

        public static var forever: Self {
            self.init(count: .infinity)
        }

        private var count: Double

        public init(integerLiteral value: Int) {
            count = Double(value)
        }

        private init(count: Double) {
            self.count = count
        }

    }

}
