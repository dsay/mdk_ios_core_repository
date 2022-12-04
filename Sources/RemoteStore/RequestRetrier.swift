import Foundation
import SwiftRepository

public enum RetryResult {
    /// Retry should be attempted immediately.
    case retry
    /// Retry should be attempted after the associated `TimeInterval`.
    case retryWithDelay(TimeInterval)
    /// Do not retry.
    case doNotRetry
}

public protocol RequestRetrier {
    
    func retry(_ request: URLRequest, session: URLSession, error: Error) async throws -> RetryResult
}

public class DefaultRequestRetrier: RequestRetrier {
    
    public init() {}

    open func retry(_ request: URLRequest, session: URLSession, error: Error) async throws -> RetryResult {
        return .doNotRetry
    }
}
