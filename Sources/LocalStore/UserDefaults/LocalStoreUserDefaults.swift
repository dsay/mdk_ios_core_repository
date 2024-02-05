import Foundation
import SwiftRepository

public class LocalStoreUserDefaults<Item: Codable>: LocalStoreDisk {
    
    public var userDefaults: UserDefaults
    public var decoder: JSONDecoder
    public var encoder: JSONEncoder

    public init(_ userDefaults: UserDefaults = UserDefaults.standard,
                _ decoder: JSONDecoder = JSONDecoder(),
                _ encoder: JSONEncoder = JSONEncoder())
    {
        self.userDefaults = userDefaults
        self.decoder = decoder
        self.encoder = encoder
    }
    
    open func get(forKey key: String) throws -> Item {
        guard let encoded = userDefaults.data(forKey: key) else {
            throw NSError.create(with: RepositoryErrorNotFound)
        }
        return try decoder.decode(Item.self, from: encoded)
    }
    
    open func remove(forKey key: String) throws {
        userDefaults.removeObject(forKey: key)
    }
    
    open func save(_ item: Item, forKey key: String) throws {
        let encoded = try encoder.encode(item)
        userDefaults.setValue(encoded, forKey: key)
    }
}
