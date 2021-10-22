import SwiftUI

/// A view whose animated content is coordinated by a supplied `AnimationConductor`.
///
/// To animate the content of a view, wrap the view in a `ConductedView` and supply an ``AnimationConductor`` stored
/// in a ``State`` property:
///
/// ```
/// struct RubberBandActivityIndicator: View {
///
///     private struct Line: Shape {
///
///         var orientation: Axis
///
///         func path(in rect: CGRect) -> Path {
///             var path = Path()
///             switch orientation {
///             case .horizontal:
///                 path.move(to: CGPoint(x: rect.minX, y: rect.midY))
///                 path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
///             case .vertical:
///                 path.move(to: CGPoint(x: rect.midX, y: rect.minY))
///                 path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
///             }
///             return path
///         }
///
///     }
///
///     private enum TrimPathStart: AnimationKey {
///         typealias Value = Double
///     }
///
///     private enum TrimPathEnd: AnimationKey {
///         typealias Value = Double
///     }
///
///     @State private var conductor = AnimationConductor([.sequential, .autoreverse, .`repeat`(.forever)]) {
///         TrimPathEnd.start(with: 0.2)
///     } animation: {
///         AnimateConcurrently {
///             Animate<TrimPathEnd>(to: 1, curve: .easeInOut, duration: 0.75)
///             Animate<TrimPathStart>(to: 0.8, curve: .easeInOut, duration: 0.5)
///                 .delayed(by: 0.5)
///         }
///     }
///
///     var body: some View {
///         ConductedView($conductor) { context in
///             ZStack {
///                 Line(orientation: .horizontal)
///                     .stroke(Color(.systemGray), style: StrokeStyle(lineWidth: 32, lineCap: .round))
///                 Line(orientation: .horizontal)
///                     .trim(from: context[TrimPathStart.self], to: context[TrimPathEnd.self])
///                     .stroke(Color.green, style: StrokeStyle(lineWidth: 32, lineCap: .round))
///             }
///         }
///         .padding()
///     }
///
/// }
public struct ConductedView<Content: View>: View {

    @Binding var conductor: AnimationConductor
    var content: (Context) -> Content

    public init(_ conductor: Binding<AnimationConductor>, @ViewBuilder content: @escaping (Context) -> Content) {
        self._conductor = conductor
        self.content = content
    }

    public var body: some View {
#if os(macOS) // TODO: remove once macOS 12 is finally released...
        BackwardsCompatibleTimelineView { date in
            let context = Context(conductor: conductor, date: date)
            content(context)
                .environment(\.animationContext, context)
                .onAppear { didAppear(at: date)

                }
        }
#else
        if #available(iOS 15.0, macOS 12.0, watchOS 8.0, *) {
            TimelineView(.animation(minimumInterval: FrameLength.standardLength, paused: false)) { baseContext in
                let context = Context(conductor: conductor, date: baseContext.date)
                content(context)
                    .environment(\.animationContext, context)
                    .onAppear { didAppear(at: baseContext.date) }
            }
        } else {
            BackwardsCompatibleTimelineView { date in
                let context = Context(conductor: conductor, date: date)
                content(context)
                    .environment(\.animationContext, context)
                    .onAppear { didAppear(at: date) }
            }
        }
#endif
    }

    private func didAppear(at time: Date) {
        if conductor.beginsPaused { return }
        conductor.start(at: time)
    }

}

public extension ConductedView {

    struct Context: AnimatedValueContext {

        public let date: Date
        private var conductor: AnimationConductor

        fileprivate init(conductor: AnimationConductor, date: Date) {
            self.conductor = conductor
            self.date = date
        }

        public subscript<Key: AnimationKey>(_ key: Key.Type) -> Key.Value {
            conductor[key, at: date]
        }

    }

}
