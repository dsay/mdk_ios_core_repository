import XCTest
@testable import LocalStoreFileManager

final class LocalStoreFileManagerTests: XCTestCase {
    
    var manager: LocalStoreFileManager!
    
    override func setUp() {
        super.setUp()
        manager = LocalStoreFileManager()
        
        deleteAll()
    }
    
    func deleteAll() {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl,
                                                                       includingPropertiesForKeys: nil,
                                                                       options: .skipsHiddenFiles)
            for fileURL in fileURLs {
                try FileManager.default.removeItem(at: fileURL)
            }
        } catch {
            print(error)
        }
    }
    
    func testIsExists() throws {
        XCTAssertFalse(manager.isExists(at: "test"))
        try manager.save(Data(), at: "test")
        XCTAssertTrue(manager.isExists(at: "test"))
    }
    
    func testGet() throws {
        do {
            let data = try manager.get(from: "test")
            XCTAssertNil(data)
        } catch {
            XCTPass()
        }
        try manager.save(Data(), at: "test")
        XCTAssertNotNil(try manager.get(from: "test"))
    }
    
    func testRemove() throws {
        try manager.save(Data(), at: "test")
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
