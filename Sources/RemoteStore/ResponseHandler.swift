import Foundation
import SwiftRepository

public protocol ResponseHandler {
        
    func handle(result: HttpResult) throws -> HttpResult
}

public class DefaultHandler: ResponseHandler {
    
    public init() {}
    
    open func isSuccess(_ statusCode: Int) -> Bool {
        switch statusCode {
        case 200..<300:
            return true
        default:
            return false
        }
    }
    
    open func handle(result: HttpResult) throws -> HttpResult {
        guard let response = result.response as? HTTPURLResponse else {
            throw NSError.create(with: RepositoryErrorUnknown)
        }
  
        if isSuccess(response.statusCode) {
            return result
        } else {
            let localizedString = HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
            throw NSError.create(with: response.statusCode, message: localizedString)
        }
    }
}
