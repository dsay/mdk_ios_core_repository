import CoreData
import SwiftRepository

public enum Configuration {
    
    // Used unique user identifier for path component <defaultDirectory>/<user>/DataBase.sqlite
    case `private`(String)
    
    // Create default path <defaultDirectory>/DataBase.sqlite
    case `public`
    
    var name: String? {
        switch self {
        case .private:
            return "Private"
            
        case .public:
            return "Public"
        }
    }
}

public struct DataBaseStore {
    
    let type: String
    let configuration: Configuration?
    
    private var defaultDirectoryURL: URL { NSPersistentContainer.defaultDirectoryURL() }
    
    public init(type: String = NSSQLiteStoreType, configuration: Configuration? = nil) {
        self.type = type
        self.configuration = configuration
    }
    
    public func createDefaultSQLiteURL() -> URL {
        switch configuration {
        case .private(let path):
            return defaultDirectoryURL.appendingPathComponent(path).appendingPathComponent("DataBase.sqlite")
            
        default:
            return defaultDirectoryURL.appendingPathComponent("DataBase.sqlite")
        }
    }
    
    public func createStoreDescription() -> NSPersistentStoreDescription {
    
        let url = createDefaultSQLiteURL()
        
        let description = NSPersistentStoreDescription(url: url)
        
        description.configuration = configuration?.name
        description.type = type
        description.shouldInferMappingModelAutomatically = true
        description.shouldMigrateStoreAutomatically = true
        
        return description
    }
}
