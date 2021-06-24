import Foundation

public protocol Syncable {
    
    associatedtype Remote: RemoteStore
    
    var remote: Remote { get }
}

public protocol RemoteStore {
    
    func send(request: RequestProvider, responseString: @escaping (Result<String, Error>) -> Void)
    func send(request: RequestProvider, responseData: @escaping (Result<Data, Error>) -> Void)
    func send(request: RequestProvider, responseJSON: @escaping (Result<Any, Error>) -> Void)
}

public protocol RemoteStoreObjects: RemoteStore {
    associatedtype Item
    
    func send(request: RequestProvider, keyPath: String?, responseObject: @escaping (Result<Item, Error>) -> Void)
    func send(request: RequestProvider, keyPath: String?, responseArray: @escaping (Result<[Item], Error>) -> Void)
}
