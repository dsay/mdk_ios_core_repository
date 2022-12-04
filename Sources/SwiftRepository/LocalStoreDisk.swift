import Foundation

public protocol LocalStoreDisk: LocalStore {
    
    associatedtype Item

    func isExists(forKey key: String) -> Bool
    func get(forKey key: String) throws -> Item
    func remove(forKey key: String) throws
    func save(_ item: Item, forKey key: String) throws
}

public extension LocalStoreDisk {
    
    func isExists(forKey key: String) -> Bool {
        do {
            let _ = try get(forKey: key)
            return true
        } catch  {
            return false
        }
    }
}
