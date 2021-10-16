import Maestro
import SwiftUI

struct RubberBandActivityIndicator: View {

    private struct Line: Shape {

        var orientation: Axis

        func path(in rect: CGRect) -> Path {
            var path = Path()
            switch orientation {
            case .horizontal:
                path.move(to: CGPoint(x: rect.minX, y: rect.midY))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            case .vertical:
                path.move(to: CGPoint(x: rect.midX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            }
            return path
        }

    }

    private enum TrimPathStart: AnimationKey {
        typealias Value = Double
    }

    private enum TrimPathEnd: AnimationKey {
        typealias Value = Double
    }

    @State private var conductor = AnimationConductor([.sequential, .autoreverse, .`repeat`(.forever)]) {
        TrimPathEnd.start(with: 0.2)
    } animation: {
        AnimateConcurrently {
            Animate<TrimPathEnd>(to: 1, curve: .easeInOut, duration: 0.75)
            Animate<TrimPathStart>(to: 0.8, curve: .easeInOut, duration: 0.5)
                .delayed(by: 0.5)
        }
    }

    var body: some View {
        ConductedView($conductor) { context in
            ZStack {
                Line(orientation: .horizontal)
                    .stroke(Color(.systemGray), style: StrokeStyle(lineWidth: 32, lineCap: .round))
                Line(orientation: .horizontal)
                    .trim(from: context[TrimPathStart.self], to: context[TrimPathEnd.self])
                    .stroke(Color.green, style: StrokeStyle(lineWidth: 32, lineCap: .round))
            }
        }
        .padding()
    }

}
