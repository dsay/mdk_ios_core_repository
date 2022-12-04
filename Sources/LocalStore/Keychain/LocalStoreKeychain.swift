import KeychainSwift
import Foundation
import SwiftRepository

open class LocalStoreKeychain<Item: Codable>: LocalStoreDisk {

    public let store: KeychainSwift

    public init(_ store: KeychainSwift) {
        self.store = store
    }

    open func get(forKey key: String) throws -> Item {
        guard let encoded = store.getData(key, asReference: false) else {
            throw NSError.create(with: RepositoryErrorNotFound)
        }
        return try JSONDecoder().decode(Item.self, from: encoded)
    }

    open func remove(forKey key: String) throws {
        store.delete(key)
    }

    open func save(_ item: Item, forKey key: String) throws {
        let encoded = try JSONEncoder().encode(item)
        store.set(encoded, forKey: key)
    }
}
