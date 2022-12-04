import Foundation
import SwiftRepository

public extension RequestProvider {
    
    var urlString: String { url.hasSuffix("/") ? String(url.dropLast()) : url }
    
    func asURL() throws -> URL {
        
        guard var url = URL(string: urlString) else {
            throw NSError.create(with: RepositoryErrorBadURL)
        }
        
        url = try path.compose(into: url)
        url = try query.compose(into: url)
        
        return url
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try self.asURL()
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = method.rawValue
        urlRequest = try body.compose(into: urlRequest)
        urlRequest = try headers.compose(into: urlRequest)

        return urlRequest
    }
}

extension String {
    
     public func escape() -> String {
        addingPercentEncoding(withAllowedCharacters: .URLQueryAllowed) ?? ""
    }
}

extension CharacterSet {
    /// Creates a CharacterSet from RFC 3986 allowed characters.
    ///
    /// RFC 3986 states that the following characters are "reserved" characters.
    ///
    /// - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
    /// - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ";", "="
    ///
    /// In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
    /// query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
    /// should be percent-escaped in the query string.
    static public let URLQueryAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+;="
        let encodableDelimiters = CharacterSet(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")

        return CharacterSet.urlQueryAllowed.subtracting(encodableDelimiters)
    }()
}
