import Foundation
import Combine

extension DependencyContainer {

    /// Observe a type, when it gets registered.
    /// - If it's already registered, return it.
    /// - If not registered, listen to dependencies and return it at the first occasion it's registered.
    public func observe<T>(_ type: T.Type) -> AnyPublisher<T, Never> {
        if let value = try? resolve(T.self) {
            return Just(value).eraseToAnyPublisher()
        }

        let key = String(describing: type)
        return $dependencies
            .filter { $0.keys.contains(key) }
            .compactMap { $0[key] as? T }
            .first()
            .eraseToAnyPublisher()
    }
}
