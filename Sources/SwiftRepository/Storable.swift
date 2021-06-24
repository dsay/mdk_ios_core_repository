import Foundation

public protocol Storable {
    
    associatedtype Local: LocalStore

    var local: Local { get }
}

public protocol LocalStore {
    
}
