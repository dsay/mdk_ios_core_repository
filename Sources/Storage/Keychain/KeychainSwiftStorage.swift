import KeychainSwift
import SwiftRepository
import Foundation

extension KeychainSwift: Storage {
  
    public func deleteValue(_ key: String) {
        delete(key)
    }
    
    public func setString(_ string: String, forKey key: String) {
        set(string, forKey: key)
    }
    
    public func setData(_ data: Data, forKey key: String) {
        set(data, forKey: key)
    }
    
    public func setBool(_ bool: Bool, forKey key: String) {
        set(bool, forKey: key)
    }
    
    public func getData(_ key: String) -> Data? {
        getData(key, asReference: false)
    }
    
    public func getString(_ key: String) -> String? {
        get(key)
    }
    
    public func getBool(_ key: String, defaultValue: Bool) -> Bool {
        getBool(key) ?? defaultValue
    }
}
