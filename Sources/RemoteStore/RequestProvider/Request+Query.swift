import Foundation
import SwiftRepository

extension Dictionary: URLComposer where Key == String, Value == String? {
    
    public func compose(into url: URL) throws -> URL {
        
        guard isEmpty == false else {
            return url
        }
        
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw NSError.create(with: RepositoryErrorBadURL)
        }
            
        var items = compactMap { URLQueryItem(name: $0, value: $1?.escape()) }
        components.queryItems.flatMap { items += $0 }
        components.queryItems = items
        
        guard let aUrl = components.url else {
            throw NSError.create(with: RepositoryErrorBadURL)
        }
        
        return aUrl
    }
}
