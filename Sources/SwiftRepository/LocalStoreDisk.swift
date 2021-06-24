import Foundation

public protocol LocalStoreDisk: LocalStore {
    
    associatedtype Item

    func isExists(at URL: String) -> Bool
    func get(from URL: String) throws -> Item
    func remove(from URL: String) throws
    func save(_ item: Item, at URL: String) throws
}
