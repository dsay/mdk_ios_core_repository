import Foundation
import SwiftRepository

public class LocalStoreUserDefaults<Item: Codable>: LocalStoreDisk {
    
    public let store: UserDefaults
    
    public init(_ store: UserDefaults) {
        self.store = store
    }
    
    open func get(forKey key: String) throws -> Item {
        guard let encoded = store.data(forKey: key) else {
            throw NSError.create(with: RepositoryErrorNotFound)
        }
        return try JSONDecoder().decode(Item.self, from: encoded)
    }
    
    open func remove(forKey key: String) throws {
        store.removeObject(forKey: key)
    }
    
    open func save(_ item: Item, forKey key: String) throws {
        let encoded = try JSONEncoder().encode(item)
        store.setValue(encoded, forKey: key)
    }
}
