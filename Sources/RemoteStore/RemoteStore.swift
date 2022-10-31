import Foundation
 
open class URLSessionRemoteStore: RemoteStore {
    
    // MARK: - Properties
    
    let session: URLSession
    
    // MARK: - Lifecycle
    
    public init(session: URLSession) {
        self.session = session
    }
    
    func dataRequest(provider: RequestProvider, decoder: JSONDecoder? = nil) async throws -> Any {
        let request = try provider.asURLRequest()
        
        let (data, response) = try await session.data(for: request)
        
        let decoder = decoder ?? JSONDecoder()
        
        return try decoder.decode(T.self, from: data)
        
        return try handle(response: response, content: data)
    }
    
    
    
    func dataRequest(request: RequestProvider, decoder: JSONDecoder? = nil) async throws -> String {
        
        let (data, response) = try await session.data(for: getRequest(request))
        
        return try handle(response: response, content: data)
    }
    func dataRequest(request: RequestProvider) async throws -> Data
    func dataRequest<Item>(request: RequestProvider) async throws -> Item
    func dataRequest<Item>(request: RequestProvider) async throws -> [Item]
    
    
    // MARK: - Methods
    
    func handle<T>(response: URLResponse, content: T) throws -> T {
//        guard let response = response as? HTTPURLResponse else {
//            throw "Unknown response received"
//        }
//
//        guard let httpStatusCode = HttpStatusCode(rawValue: response.statusCode) else {
//            throw "Unknown http status code"
//        }
//
//        if httpStatusCode.isSuccessStatusCode {
//            return content
//        } else if let content = content as? Data {
//            throw try JSONDecoder().decode(Request.Error.self, from: content)
//        } else {
//            throw Request.Error(code: response.statusCode)
//        }
    }
}
