import Foundation
import SwiftRepository

extension Dictionary: RequestComposer where Key == String, Value == String {
    
    public func compose(into request: URLRequest) throws -> URLRequest {
       
        var request = request
   
        request.setHTTPHeader(HTTPHeader.default)
        request.setHTTPHeader(self)

        return request
    }
}

extension URLRequest {

    mutating func setHTTPHeader(_ HTTPHeader: [String: String]) {
        HTTPHeader.forEach {
            self.setValue($1, forHTTPHeaderField: $0)
        }
    }
}
