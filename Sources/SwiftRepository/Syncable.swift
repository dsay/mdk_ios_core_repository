import Foundation

public protocol Syncable {
    
    associatedtype Remote: RemoteStore
    
    var remote: Remote { get }
}

public protocol RemoteStore {
    
}
