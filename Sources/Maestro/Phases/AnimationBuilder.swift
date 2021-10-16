import Foundation

@resultBuilder public struct _ArrayBuilder<T> {

    public static func buildArray(_ components: [T]) -> [T] {
        components
    }

    public static func buildBlock(_ components: T...) -> [T] {
        components
    }

    public static func buildOptional(_ component: [T]?) -> [T] {
        component ?? []
    }

}

public typealias AnimationBuilder = _ArrayBuilder<AnimationPhase>
public typealias AnimationStateBuilder = _ArrayBuilder<AnimationState.Property>
