import KeychainSwift
import Foundation
import SwiftRepository

open class LocalStoreKeychain<Item: Codable>: LocalStoreDisk {
    
    public var keychain: KeychainSwift
    public var decoder: JSONDecoder
    public var encoder: JSONEncoder
    
    public init(_ keychain: KeychainSwift,
                _ decoder: JSONDecoder = JSONDecoder(),
                _ encoder: JSONEncoder = JSONEncoder())
    {
        self.keychain = keychain
        self.decoder = decoder
        self.encoder = encoder
    }
    
    open func get(forKey key: String) throws -> Item {
        guard let encoded = keychain.getData(key, asReference: false) else {
            throw NSError.create(with: RepositoryErrorNotFound)
        }
        return try decoder.decode(Item.self, from: encoded)
    }

    open func remove(forKey key: String) throws {
        keychain.delete(key)
    }

    open func save(_ item: Item, forKey key: String) throws {
        let encoded = try encoder.encode(item)
        keychain.set(encoded, forKey: key)
    }
}
