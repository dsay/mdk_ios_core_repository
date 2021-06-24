import XCTest
import SwiftRepository
import Foundation

@testable import UserDefaultsStorage

final class UserDefaultsStorageTests: XCTestCase {
    
    var storage: Storage = UserDefaults.standard
    
    override func setUp() {
        super.setUp()
       
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
    
    func testSetString() {
        let value = "Test"
        let key = "Key"
        storage.setString(value, forKey: key)
        XCTAssertEqual(value, storage.getString(key))
    }
    
    func testSetBool() {
        let value = true
        let key = "Key"
        storage.setBool(value, forKey: key)
        
        XCTAssertEqual(value, storage.getBool(key, defaultValue: false))
    }
    
    func testSetData() {
        let value = Data()
        let key = "Key"
        storage.setData(value, forKey: key)
        
        XCTAssertEqual(value, storage.getData(key))
    }

    func testDefaultBool() {
        let key = "Key"
        XCTAssertEqual(true, storage.getBool(key, defaultValue: true))
    }
    
    func testDelete() {
        let key = "Key"
        storage.setString("Some", forKey: key)
        XCTAssertNotEqual(storage.getString(key), nil)

        storage.deleteValue(key)
        
        XCTAssertEqual(storage.getString(key), nil)
    }
    
    func testTypes() {
        let key = "Key"
        storage.setString("Some", forKey: key)
        
        XCTAssertEqual(storage.getData(key), nil)
    }
    
    static var allTests = [
        ("testSetString", testSetString),
        ("testSetBool", testSetBool),
        ("testSetData", testSetData),
        ("testDefaultBool", testDefaultBool),
        ("testDelete", testDelete),
        ("testTypes", testTypes),
    ]
}
