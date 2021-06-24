import SwiftRepository
import Foundation

extension UserDefaults: Storage {

    public func setString(_ string: String, forKey key: String) {
        setValue(string, forKey: key)
    }
    
    public func setData(_ data: Data, forKey key: String) {
        setValue(data, forKey: key)
    }
    
    public func setBool(_ bool: Bool, forKey key: String) {
        setValue(bool, forKey: key)
    }
    
    public func getData(_ key: String) -> Data? {
        value(forKey: key) as? Data
    }
    
    public func getString(_ key: String) -> String? {
        value(forKey: key) as? String
    }
    
    public func getBool(_ key: String, defaultValue: Bool) -> Bool {
        value(forKey: key) as? Bool ?? defaultValue
    }
    
    public func deleteValue(_ key: String) {
        removeObject(forKey: key)
    }
}
