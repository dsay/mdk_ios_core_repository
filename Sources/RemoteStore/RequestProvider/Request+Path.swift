import Foundation
import SwiftRepository

extension String: URLComposer {
    
    public func compose(into url: URL) throws -> URL {
        return self.isEmpty ? url : url.appendingPathComponent(self.escape())
    }
}

extension Array: URLComposer where Element == String {
    
    public func compose(into url: URL) throws -> URL {
        return try self.reduce(url) { try $1.compose(into: $0) }
    }
}

public extension String  {
    
    @inlinable static func / (lhs: String, rhs: String) -> String {
        return rhs.isEmpty ? lhs : lhs + "/" + rhs
    }
}
