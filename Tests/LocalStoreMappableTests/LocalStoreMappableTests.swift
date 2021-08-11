import XCTest
import ObjectMapper
@testable import LocalStoreMappable

class User: Mappable {

    init() {
        
    }
    
    required init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        
    }
}

final class LocalStoreMappableTests: XCTestCase {

    var manager: LocalStoreMappable<User>!
    
    override func setUp() {
        super.setUp()
        manager = LocalStoreMappable(InMemoryStorage())
    }
    
    func testIsExists() throws {
        XCTAssertFalse(manager.isExists(at: "test"))
        try manager.save(User(), at: "test")
        XCTAssertTrue(manager.isExists(at: "test"))
    }
    
    func testGet() throws {
        do {
            let data = try manager.get(from: "test")
            XCTAssertNil(data)
        } catch {
            XCTPass()
        }
        try manager.save(User(), at: "test")
        XCTAssertNotNil(try manager.get(from: "test"))
    }
    
    func testRemove() throws {
        try manager.save(User(), at: "test")
        XCTAssertTrue(manager.isExists(at: "test"))
        try manager.remove(from: "test")
        XCTAssertFalse(manager.isExists(at: "test"))
    }
    
    static var allTests = [
        ("testIsExists", testIsExists),
        ("testGet", testGet),
        ("testRemove", testRemove),
    ]
}

extension XCTestCase {
    
    func XCTPass() {
        XCTAssertTrue(true)
    }
}
