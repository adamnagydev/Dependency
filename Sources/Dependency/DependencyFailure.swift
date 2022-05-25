import Foundation

/// Possible failure types, during dependency injection/resolving.
public enum DependencyFailure: Error, LocalizedError {

    /// When tried to get a dependency
    /// without being registered to a container.
    case notRegistered(dependencyName: String)

    public var errorDescription: String? {
        switch self {
        case .notRegistered(let name):
            return "\(name) is a not registered dependency."
        }
    }
}
