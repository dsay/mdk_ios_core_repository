import Foundation
import Combine

extension Task where Success == Never, Failure == Never {
    
    static public func sleep(_ timeInterval: TimeInterval) async throws {
        let duration = UInt64(timeInterval)
        try await Task.sleep(nanoseconds: duration)
    }
}

extension Future where Failure == Error {
    
    convenience public init(asyncFunc: @escaping () async throws -> Output) {
        self.init { promise in
            Task {
                do {
                    let result = try await asyncFunc()
                    promise(.success(result))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }
}
