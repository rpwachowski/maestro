import Foundation

public struct AnimationState {

    public struct Property: Identifiable {

        public var id: AnyHashable
        private var value: Any

        public init<Key: AnimationKey>(_ key: Key.Type, _ value: Key.Value) {
            id = ObjectIdentifier(key)
            self.value = value
        }

        subscript<Key: AnimationKey>(_ key: Key.Type) -> Key.Value? {
            AnyHashable(ObjectIdentifier(key)) == id ? value as? Key.Value : nil
        }

    }

    private var properties: [AnyHashable: Property]

    /// Initializes an `AnimationState` with no initial values.
    ///
    /// All initial values will be derived from the default values of animation keys.
    public init() {
        properties = [:]
    }

    /// Initializes an `AnimationState` with the supplied initial values.
    public init(@AnimationStateBuilder values: () -> [Property]) {
        // Intentionally left verbose with argument labels and unused variables so that it's clear what is happening.
        // In the builder structure, this'll always take the last of duplicated properties:
        //
        // AnimationState {
        //     Property<SomeDoubleKey>(1.0)      Dropped
        //     if someCase {
        //         Property<SomeDoubleKey>(0.5)  Dropped
        //     }
        //     Property<SomeDoubleKey>(0.3)      Final value
        // }
        self.properties = Dictionary(values().map { ($0.id, $0) }, uniquingKeysWith: { first, second in second })
    }

    subscript<Key: AnimationKey>(_ key: Key.Type) -> Key.Value {
        properties[ObjectIdentifier(key)]?[key] ?? Key.defaultValue
    }

}
