import Foundation

/// Resolve a dependency from a container by type.
public protocol DependencyResolver {
    func resolve<T>(_ type: T.Type) throws -> T
    func resolve<T>() throws -> T
}
