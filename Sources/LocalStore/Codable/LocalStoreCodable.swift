import Foundation
import SwiftRepository

open class LocalStoreCodable<Item: Codable>: LocalStoreDisk {
    
    public let store: Storage
    
    public init(_ store: Storage) {
        self.store = store
    }
    
    public func isExists(at URL: String) -> Bool {
        store.getData(URL) != nil
    }
    
    public func get(from URL: String) throws -> Item {
        guard let encoded = store.getData(URL) else {
            throw RepositoryError.notFound
        }
        return try JSONDecoder().decode(Item.self, from: encoded)
    }
    
    public func remove(from URL: String) throws {
        store.deleteValue(URL)
    }
    
    public func save(_ item: Item, at URL: String) throws {
        let encoded = try JSONEncoder().encode(item)
        store.setData(encoded, forKey: URL)
    }
}
