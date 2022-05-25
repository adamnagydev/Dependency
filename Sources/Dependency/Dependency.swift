import Foundation
import Combine
import SwiftUI

/// Dependency instance resolver.
/// Get a dependency from the global container.
@propertyWrapper
public struct Dependency<Value> {
    public let wrappedValue: Value

    public init() {
        guard let container = DependencyContainerStore.instance.container else {
            fatalError("There's no registered container.")
        }

        do {
            wrappedValue = try container.resolve(Value.self)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

/// Dependency instance resolver in a lazy way.
/// It's going to be resolved for the first time whenever it's accessed.
/// Get a dependency from the global container.
@propertyWrapper
public class LazyDependency<Value> {
    public var wrappedValue: Value {
        innerValue
    }

    private lazy var innerValue: Value = build()

    public init() {}

    private func build() -> Value {
        guard let container = DependencyContainerStore.instance.container else {
            fatalError("There's no registered container.")
        }

        do {
            return try container.resolve(Value.self)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

/// Observable dependency.
/// Used to inject an observable dependency in a View.
@propertyWrapper public struct ObservedDependency<Value>: DynamicProperty where Value: ObservableObject {
    @ObservedObject private var value: Value

    public init() {
        guard let container = DependencyContainerStore.instance.container else {
            fatalError("There's no registered container.")
        }

        do {
            self.value = try container.resolve(Value.self)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    public var wrappedValue: Value {
        get { value }
        mutating set { value = newValue }
    }

    public var projectedValue: ObservedObject<Value>.Wrapper {
        $value
    }
}
