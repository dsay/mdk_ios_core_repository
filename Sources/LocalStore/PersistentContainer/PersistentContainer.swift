import CoreData
import Foundation

open class Database {
    
    public enum Configuration {
        case `default`
        case `private`
        case `public`
    }
    
    public let container: NSPersistentContainer
    
    private var coordinator: NSPersistentStoreCoordinator { container.persistentStoreCoordinator }
    private var defaultDirectoryURL: URL { NSPersistentContainer.defaultDirectoryURL() }
    
    public init(name: String) {
        self.container = NSPersistentContainer(name: name)
    }

    private func createURL(_ name: String?) -> URL {
        name.flatMap(createSQLiteURL) ?? createDefaultSQLiteURL()
    }
    
    private func createSQLiteURL(_ name: String) -> URL {
        defaultDirectoryURL.appendingPathComponent(name).appendingPathComponent("\(container.name).sqlite")
    }
    
    private func createDefaultSQLiteURL() -> URL {
        defaultDirectoryURL.appendingPathComponent("\(container.name).sqlite")
    }
    
    open func createStoreDescription(_ name: String? = nil,
                                     type: String = NSSQLiteStoreType,
                                     configuration: Configuration = .default) -> NSPersistentStoreDescription
    {
        let description = NSPersistentStoreDescription(url: createURL(name))
        description.configuration = configuration.name
        description.type = type
        description.shouldInferMappingModelAutomatically = true
        description.shouldMigrateStoreAutomatically = true
        
        return description
    }
    
    open func addStores(_ descriptions: [NSPersistentStoreDescription], _ completionHandler: @escaping (Result<Void, Error>) -> Void) {
        
        var completed: [Error?] = []
        
        container.persistentStoreDescriptions = descriptions
        container.loadPersistentStores(completionHandler: { [weak self] description, error in
            guard let self = self else {
                return
            }

            if error != nil {
                do {
                    try self.destroyPersistentStoreDescription(description)
                } catch {
                    completed.append(error)
                }
            } else {
                completed.append(nil)
            }
            
            if completed.count == descriptions.count {
                if let error = completed.compactMap({ $0 }).last {
                    completionHandler(.failure(error))
                } else {
                    completionHandler(.success())
                }
            }
        })
    }
    
    open func destroyPersistentStoreDescription(_ description: NSPersistentStoreDescription) throws {
        guard let url = description.url else {
            return
        }
        try self.coordinator.destroyPersistentStore(at: url, ofType: description.type, options: nil)
    }
}

extension Database.Configuration {
    
    var name: String? {
        switch self {
        case .default:
            return nil
        case .private:
            return "Private"
        case .public:
            return "Public"
        }
    }
}

extension Result where Success == Void {
    
    public static func success() -> Self { .success(()) }
}
