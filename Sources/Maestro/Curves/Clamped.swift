import Foundation

@propertyWrapper struct Clamped<Value: Comparable> {

    private var lowerBound: Value
    private var upperBound: Value
    private var value: Value

    init(wrappedValue: Value, _ lowerBound: Value, _ upperBound: Value) {
        self.lowerBound = lowerBound
        self.upperBound = upperBound
        self.value = wrappedValue
    }

    var wrappedValue: Value {
        if value <= lowerBound { return lowerBound }
        if value >= upperBound { return upperBound }
        return value
    }

}
