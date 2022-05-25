import XCTest
@testable import Dependency

final class DependencyTests: XCTestCase {

    /// Container used to test resolving/registering.
    private let container = DependencyContainer()

    override func setUp() {
        DependencyContainerStore.instance.register(container: container)
    }

    override func tearDown() {
        DependencyContainerStore.instance.deregister()
    }

    func testResolvingUnregisteredDependency() {
        XCTAssertThrowsError(try container.resolve(AnyTestService.self))
    }

    func testRegisterDependency() throws {
        let service: AnyTestService = TestService()
        container.register(AnyTestService.self, object: service)

        let resolvedService = try container.resolve(AnyTestService.self)
        XCTAssertTrue(service === resolvedService)
    }

    func testRegisterDependencyWithChildren() throws {
        let child: AnyTestService = TestService()
        container.register(AnyTestService.self, object: child)

        container.register(AnyServiceWithChildren.self) { resolver throws in
            ServiceWithChildren(
                childService: try resolver.resolve()
            )
        }

        _ = try container.resolve(AnyServiceWithChildren.self)
    }
}

protocol AnyTestService: AnyObject {}

final class TestService: AnyTestService {}

protocol AnyServiceWithChildren: AnyObject {}

final class ServiceWithChildren: AnyServiceWithChildren {
    private let childService: AnyTestService

    init(childService: AnyTestService) {
        self.childService = childService
    }
}
