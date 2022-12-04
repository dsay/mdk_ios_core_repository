import Foundation
import SwiftRepository

public protocol RequestAdapter {
    
    func adapt(_ request: URLRequest, session: URLSession) async throws -> URLRequest
}

public class DefaultRequestAdapter: RequestAdapter {
    
    public init() {}
    
    open func adapt(_ request: URLRequest, session: URLSession) async throws -> URLRequest {
        return request
    }
}
