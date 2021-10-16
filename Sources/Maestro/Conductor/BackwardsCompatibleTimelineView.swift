import SwiftUI

struct BackwardsCompatibleTimelineView<Content: View>: View {

    class Model: ObservableObject {

        private let timer = Timer.publish(every: UIScreen.main.frameLength, tolerance: nil, on: .main, in: .default).autoconnect()

        @Published private(set) var currentDate = Date()

        func connect() {
            currentDate = Date()
            timer.assign(to: &$currentDate)
        }

    }

    @ViewBuilder var content: (Date) -> Content
    @StateObject private var model = Model()

    var body: some View {
        content(model.currentDate)
            .onAppear(perform: model.connect)
    }

}
