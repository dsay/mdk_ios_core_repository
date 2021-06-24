import Foundation

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

// MARK: - RequestProvider

   /// Creates a `RequestProvider` to retrieve the contents of the specified `url`, `method`, `path`, `query`
   /// , `body` and `headers`.
   ///
   /// - parameter url:        The URL.
   /// - parameter method:     The HTTPMethod enum.
   /// - parameter path:       The RequestPathConvertible adds in the end of URL. Use next format `/user/1` or `[/user, 1]`
   /// - parameter query: The queryItems adds in the URL after `?` all items separate by `&` `?search&name=Artur&age=27`.
   /// - parameter headers:    The HTTP headers.
   /// - parameter body:       The RequestBodyConvertible. By encode parameters to `httpBody`.

public protocol URLComposer {
    
    func compose(into url: URL) throws -> URL
}

public protocol RequestComposer {

    func compose(into request: URLRequest) throws -> URLRequest
}

public protocol RequestProvider {
    
    var method: HTTPMethod { get }
    
    var url: String { get }
    
    var path: URLComposer { get }
    var query: URLComposer { get }
    
    var headers: RequestComposer { get }
    var body: RequestComposer { get }
    
    func asURL() throws -> URL
    
    func asURLRequest() throws -> URLRequest
}
