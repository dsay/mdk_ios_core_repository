import Foundation
import SwiftRepository

class InMemoryStorage: Storage {

    var store: [String: Any] = [:]
    
    func setString(_ string: String, forKey key: String) {
        store[key] = string
    }
    
    func setData(_ data: Data, forKey key: String) {
        store[key] = data
    }
    
    func setBool(_ bool: Bool, forKey key: String) {
        store[key] = bool
    }

    func getData(_ key: String) -> Data? {
        store[key] as? Data
    }
    
    func getString(_ key: String) -> String? {
        store[key] as? String
    }
    
    func getBool(_ key: String, defaultValue: Bool) -> Bool {
        store[key] as? Bool ?? defaultValue
    }
    
    func deleteValue(_ key: String) {
        store[key] = nil
    }
}
