import Foundation

/// Container to register and resolve dependencies.
public final class DependencyContainer: DependencyResolver {

    /// Array of stored dependencies.
    @Published
    public private(set) var dependencies: [String: Any]

    public init() {
        dependencies = [:]
    }

    public func removeAll() {
        dependencies.removeAll()
    }
}

// MARK: Register - by protocol

public extension DependencyContainer {

    /// Register a dependency for a given type.
    func register<T, D>(_ type: T.Type, object: D) {
        let key = String(describing: type)
        let value = object as Any

        dependencies[key] = value
    }

    /// Register a dependency for a given type, by using a resolver.
    func register<D: AnyObject, T>(_ type: T.Type, resolver: (DependencyResolver) throws -> D) {
        let key = String(describing: type)

        do {
            dependencies[key] = try resolver(self)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

// MARK: Register - by object

public extension DependencyContainer {

    /// Register a dependency.
    func register<D>(_ object: D) {
        let key = String(describing: D.self)
        let value = object as Any

        dependencies[key] = value
    }

    /// Register a dependency for a given type, by using a resolver.
    func register<D: AnyObject>(_ resolve: (DependencyResolver) throws -> D) {
        let key = String(describing: D.self)

        do {
            dependencies[key] = try resolve(self)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

// MARK: Resolve

public extension DependencyContainer {

    /// Resolve a dependency for a given type.
    func resolve<T>(_ type: T.Type) throws -> T {
        let key = String(describing: type)

        if let value = dependencies[key] as? T {
            return value
        } else {
            throw DependencyFailure.notRegistered(dependencyName: key)
        }
    }

    func resolve<T>() throws -> T {
        try resolve(T.self)
    }
}
