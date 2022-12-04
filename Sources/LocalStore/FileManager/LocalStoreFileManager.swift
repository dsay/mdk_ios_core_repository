import Foundation
import SwiftRepository

open class LocalStoreFileManager<Item: Codable>: LocalStoreDisk {
        
    public lazy var documentsDirectory: URL = {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }()
    
    public init() {
        
    }
    
    open func isExists(forKey key: String) -> Bool {
        let fileURL = documentsDirectory.appendingPathComponent(key)
        return FileManager.default.fileExists(atPath: fileURL.path)
    }
    
    open func get(forKey key: String) throws -> Item {
        let fileURL = documentsDirectory.appendingPathComponent(key)
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode(Item.self, from: data)
    }
    
    open func remove(forKey key: String) throws {
        let fileURL = documentsDirectory.appendingPathComponent(key)
        try FileManager.default.removeItem(at: fileURL)
    }
    
    open func save(_ item: Item, forKey key: String) throws {
        let encoded = try JSONEncoder().encode(item)
        let fileURL = documentsDirectory.appendingPathComponent(key)
        try encoded.write(to: fileURL)
    }
}
