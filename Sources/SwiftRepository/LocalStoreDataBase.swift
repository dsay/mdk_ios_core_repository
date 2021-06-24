import Foundation

public enum UpdatePolicy: Int {
    case error = 1
    case modified = 3
    case all = 2
}

public protocol LocalStoreDataBase: LocalStore {
    
    associatedtype Item
    
    func getItems(response: @escaping (Result<[Item], RepositoryError>) -> Void)
    func getItem(response: @escaping (Result<Item, RepositoryError>) -> Void)
    func get(with id: Int, response: @escaping (Result<Item, RepositoryError>) -> Void)
    func get(with id: String, response: @escaping (Result<Item, RepositoryError>) -> Void)
    func get(with predicate: NSPredicate, response: @escaping (Result<[Item], RepositoryError>) -> Void)

    func update(_ write: @escaping () -> Void, response: @escaping (Result<Void, RepositoryError>) -> Void)

    func save(_ item: Item, policy: UpdatePolicy, response: @escaping (Result<Void, RepositoryError>) -> Void)
    func save(_ items: [Item], policy: UpdatePolicy, response: @escaping (Result<Void, RepositoryError>) -> Void)
    
    func remove(_ item: Item, response: @escaping (Result<Void, RepositoryError>) -> Void)
    func remove(_ items: [Item], response: @escaping (Result<Void, RepositoryError>) -> Void)
}
