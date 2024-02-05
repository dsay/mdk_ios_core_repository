import Foundation
import SwiftRepository

open class LocalStoreFileManager<Item: Codable>: LocalStoreDisk {
       
    public var fileManager: FileManager
    public var decoder: JSONDecoder
    public var encoder: JSONEncoder
    
    public lazy var documentsDirectory: URL = {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }()
    
    public init(_ fileManager: FileManager = FileManager.default,
                _ decoder: JSONDecoder = JSONDecoder(),
                _ encoder: JSONEncoder = JSONEncoder())
    {
        self.fileManager = fileManager
        self.decoder = decoder
        self.encoder = encoder
    }

    open func isExists(forKey key: String) -> Bool {
        let fileURL = documentsDirectory.appendingPathComponent(key)
        return fileManager.fileExists(atPath: fileURL.path)
    }
    
    open func get(forKey key: String) throws -> Item {
        let fileURL = documentsDirectory.appendingPathComponent(key)
        let data = try Data(contentsOf: fileURL)
        return try decoder.decode(Item.self, from: data)
    }
    
    open func remove(forKey key: String) throws {
        let fileURL = documentsDirectory.appendingPathComponent(key)
        try fileManager.removeItem(at: fileURL)
    }
    
    open func save(_ item: Item, forKey key: String) throws {
        let encoded = try encoder.encode(item)
        let fileURL = documentsDirectory.appendingPathComponent(key)
        try encoded.write(to: fileURL, options: [.atomic, .completeFileProtection])
    }
}
