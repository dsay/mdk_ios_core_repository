import Foundation

public enum UpdatePolicy: Int {
    case error = 1
    case modified = 3
    case all = 2
}

public protocol LocalStoreDataBase: LocalStore {
    
}
