import Foundation
import SwiftRepository

open class LocalStoreFileManager: LocalStoreDisk {
        
    public lazy var documentsDirectory: URL = {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }()
    
    public init() {
        
    }
    
    open func isExists(at URL: String) -> Bool {
        let fileURL = documentsDirectory.appendingPathComponent(URL)
        return FileManager.default.fileExists(atPath: fileURL.path)
    }
    
    open func get(from URL: String) throws -> Data {
        let fileURL = documentsDirectory.appendingPathComponent(URL)
        return try Data(contentsOf: fileURL)
    }
    
    open func remove(from URL: String) throws {
        let fileURL = documentsDirectory.appendingPathComponent(URL)
        try FileManager.default.removeItem(at: fileURL)
    }
    
    open func save(_ item: Data, at URL: String) throws {
        let fileURL = documentsDirectory.appendingPathComponent(URL)
        try item.write(to: fileURL)
    }
}
