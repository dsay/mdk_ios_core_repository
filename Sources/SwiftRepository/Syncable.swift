import Foundation

public protocol Syncable {
    
    associatedtype Remote: RemoteStore
    
    var remote: Remote { get }
}

public protocol RemoteStore {
    
    func dataRequest(request: RequestProvider) async throws -> Any
    func dataRequest(request: RequestProvider) async throws -> String
    func dataRequest(request: RequestProvider) async throws -> Data
    func dataRequest<Item>(request: RequestProvider) async throws -> Item
    func dataRequest<Item>(request: RequestProvider) async throws -> [Item]
}
