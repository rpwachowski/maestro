import Foundation

public extension AnimationConductor {

    /// Options for the root behavior of an `AnimationConductor`.
    struct Options: ExpressibleByArrayLiteral {

        private enum Case: Equatable {
            case beginsPaused
            case rootAnimation(RootAnimation)
            case autoreverse
            case `repeat`(Repetition)
        }

        /// Animations are performed forwards (from `t = 0` to `t = 1`) and then immediately reversed (from `t = 1` to `t = 0`), extending
        /// an animation cycle to include both forwards- and backwards-interpolation.
        public static var autoreverse: Self {
            self.init(.autoreverse)
        }

        /// The conductor begins paused.
        ///
        /// By default, the conductor will start animating once it appears.
        public static var beginsPaused: Self {
            self.init(.beginsPaused)
        }

        /// Animations in the root animation builder are performed concurrently.
        ///
        /// This is equivalent to supplying a single `AnimateConcurrently` animation phase to a conductor.
        public static var concurrent: Self {
            self.init(.rootAnimation(.concurrent))
        }

        /// Animations in the root animation builder are performed sequentially.
        ///
        /// This is equivalent to supplying a single `AnimateSequentially` animation phase to a conductor.
        public static var sequential: Self {
            self.init(.rootAnimation(.sequential))
        }

        /// The animation represented by the conductor will be repeated the given number of times
        ///
        /// A non-repeating animation performs a single cycle, which is equivalent to `.repeat(0)`.
        public static func `repeat`(_ repetition: Repetition) -> Self {
            self.init(.repeat(repetition))
        }

        private var cases: [Case]

        var beginsPaused: Bool {
            cases.contains(.beginsPaused)
        }

        public init(arrayLiteral elements: Options...) {
            cases = Array(elements.map(\.cases).joined())
        }

        private init(_ case: Case) {
            cases = [`case`]
        }

        func rootAnimation(@AnimationBuilder containing phases: () -> [AnimationPhase]) -> AnimationPhase {
            (cases.lazy.compactMap { `case` -> RootAnimation.Generator? in
                if case .rootAnimation(let rootAnimation) = `case` { return rootAnimation.generator }
                return nil
            }.first ?? RootAnimation.sequential.generator)(phases)
        }

        func t(referenceTime: AnimationConductor.PlaybackReferenceTime, currentTime: Date, animationCycle: TimeInterval) -> Double {
            let coalescedTime = referenceTime.t * animationCycle
            let elapsedTime = currentTime.timeIntervalSince(referenceTime.time.addingTimeInterval(-coalescedTime))
            let numberOfIterations = (cases.lazy.compactMap { `case` -> Repetition? in
                if case .repeat(let repetition) = `case` { return repetition }
                return nil
            }.first ?? 1)
            let autoreverses = self.cases.contains(.autoreverse)
            guard Int(floor(elapsedTime / (animationCycle * (autoreverses ? 2 : 1)))) < numberOfIterations else { return 1 }
            if autoreverses && !Int(floor(elapsedTime / animationCycle)).isMultiple(of: 2) {
                return 1 - elapsedTime.truncatingRemainder(dividingBy: animationCycle) / animationCycle
            } else {
                return elapsedTime.truncatingRemainder(dividingBy: animationCycle) / animationCycle
            }
        }

    }

}
