import Foundation

extension JSONSerialization {
    
    class public func jsonObject(with data: Data,
                                 options opt: JSONSerialization.ReadingOptions,
                                 keyPath: String?) throws -> Any
    {
        let json = try jsonObject(with: data, options: [])
        
        guard let keyPath = keyPath else {
            return json
        }
        
        guard let nestedJson = (json as AnyObject).value(forKeyPath: keyPath) else {
            throw NSError.create(with: RepositoryErrorKeyPathNotFound)
        }
        
        return nestedJson
    }
}
