import ObjectMapper
import SwiftRepository
import Foundation

open class LocalStoreMappable<Item: BaseMappable>: LocalStoreDisk {
    
    public let store: Storage
    
    public init(_ store: Storage) {
        self.store = store
    }
    
    open func isExists(at URL: String) -> Bool {
        store.getString(URL) != nil
    }
    
    open func get(from URL: String) throws -> Item {
        let mapper = Mapper<Item>(context: nil, shouldIncludeNilValues: false)
        guard let object = store.getString(URL),
            let parsedObject = mapper.map(JSONString: object) else {
                throw RepositoryError.notFound
        }
        return parsedObject
    }
    
    open func remove(from URL: String) throws {
        store.deleteValue(URL)
    }
    
    open func save(_ item: Item, at URL: String) throws {
        guard let JSONString = item.toJSONString() else {
            throw RepositoryError.notSave
        }
        store.setString(JSONString, forKey: URL)
    }
}
