import SwiftUI

extension VectorArithmetic {

    func scaled(by value: Double) -> Self {
        var copy = self
        copy.scale(by: value)
        return copy
    }

}
