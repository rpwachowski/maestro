import Foundation

/// A type which interpolates between an initial and target value according to a given ``Blend`` factor.
public protocol Interpolator<Value>: Hashable {
    associatedtype Value

    /// Returns the interpolated value at the argument ``Blend``.
    func value(at t: Blend) -> Value

}

/// An ``Interpolator`` which modifies the rate of change of a value by transforming an input ``Blend``.
public typealias TimingFunction = Interpolator<Blend>
