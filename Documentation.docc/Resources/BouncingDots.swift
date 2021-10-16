import Maestro
import SwiftUI

struct BouncingDots: View {

    private enum VerticalOffset<Indicator>: AnimationKey {
        typealias Value = Double
    }

    private enum SpringRigidity: AnimationKey {
        typealias Value = Self

        static var defaultValue: Self { .rigid }

        case rigid
        case flexible

    }

    private enum Indicator1 { }
    private enum Indicator2 { }
    private enum Indicator3 { }

    @State private var conductor = AnimationConductor([.sequential, .repeat(.forever)], delay: 0.25) {
        Staggered(by: 0.25) {
            Jump<VerticalOffset<Indicator1>>(to: -16)
            Jump<VerticalOffset<Indicator2>>(to: -16)
            Jump<VerticalOffset<Indicator3>>(to: -16)
        }
        Delay(duration: 0.5)
        Jump<SpringRigidity>(to: .flexible)
        Staggered(by: 0.25) {
            Jump<VerticalOffset<Indicator1>>(to: 0)
            Jump<VerticalOffset<Indicator2>>(to: 0)
            Jump<VerticalOffset<Indicator3>>(to: 0)
        }
        Delay(duration: 1)
    }

    var body: some View {
        ConductedView($conductor) { context in
            HStack {
                indicator(Indicator1.self, provider: context)
                indicator(Indicator2.self, provider: context)
                indicator(Indicator3.self, provider: context)
            }
        }
        .padding()
    }

    private func indicator<T>(_ type: T.Type, provider: AnimatedValueContext) -> some View {
        Circle()
            .fill(Color.blue)
            .frame(width: 16, height: 16)
            .animation(spring(with: provider[SpringRigidity.self]), value: provider[VerticalOffset<T>.self])
            .offset(y: provider[VerticalOffset<T>.self])
    }

    private func spring(with rigidity: SpringRigidity) -> Animation {
        .spring(response: rigidity == .rigid ? 0.4 : 0.8, dampingFraction: rigidity == .rigid ? 0.4 : 0.2, blendDuration: 0)
    }

}
