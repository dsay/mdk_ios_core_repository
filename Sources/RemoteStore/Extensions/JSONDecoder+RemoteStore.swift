import Foundation
import SwiftRepository

extension JSONDecoder {
    
    public func decode<T: Decodable>(_ type: T.Type, from data: Data, keyPath: String?) throws -> T {
        guard let keyPath = keyPath else {
            return try decode(type, from: data)
        }
        
        let toplevel = try JSONSerialization.jsonObject(with: data)
        
        guard let nestedJson = (toplevel as AnyObject).value(forKeyPath: keyPath) else {
            throw NSError.create(with: RepositoryErrorKeyPathNotFound)
        }
        
        let data = try JSONSerialization.data(withJSONObject: nestedJson)
        
        return try decode(type, from: data)
    }
}
