import Foundation

/// The global Dependency Container Store, which holds the container with the registered dependencies.
/// Used to be able to control the container, register a different one or remove it. Useful for testing purposes.
public final class DependencyContainerStore {
    private(set) var container: DependencyContainer?
    private init() {}

    public static let instance = DependencyContainerStore()

    public func register(container: DependencyContainer) {
        self.container = container
    }

    public func deregister() {
        container?.removeAll()
        container = nil
    }
}
