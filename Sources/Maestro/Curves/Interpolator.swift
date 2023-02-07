import Foundation

public protocol Interpolator<Value>: Hashable {
    associatedtype Value
    func value(at t: Blend) -> Value
}

public typealias TimingFunction = Interpolator<Blend>
