import CoreData
import SwiftRepository

private extension UpdatePolicy {

    func toCoreData() -> Any {
        switch self {
        case .all:
            return NSOverwriteMergePolicy

        case .error:
            return NSErrorMergePolicy
            
        case .modified:
            return NSMergeByPropertyObjectTrumpMergePolicy
        }
    }
}
    
open class LocalStoreCoreData: LocalStoreDataBase {

    public let context: NSManagedObjectContext

    public init(_ context: NSManagedObjectContext) {
        self.context = context
    }

    open func createFetchRequest<T: NSManagedObject>() throws -> NSFetchRequest<T> {
        guard let name = T.entity().name else {
            throw NSError.create(with: RepositoryErrorNotFound)
        }
        
        return NSFetchRequest(entityName: name)
    }
    
    open func getItem<T: NSManagedObject>() throws -> T {
        let fetchRequest: NSFetchRequest<T> = try createFetchRequest()
        fetchRequest.fetchLimit = 1
        
        let objects = try context.fetch(fetchRequest)
        
        if let foundObject = objects.first {
            return foundObject
        } else {
            throw NSError.create(with: RepositoryErrorNotFound)
        }
    }

    open func getItems<T: NSManagedObject>() throws -> [T] {
        let fetchRequest: NSFetchRequest<T> = try createFetchRequest()

        return try context.fetch(fetchRequest)
    }

    open func get<T: NSManagedObject & Identifiable>(with id: any Hashable) throws -> T {
        let fetchRequest: NSFetchRequest<T> = try createFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == \(id)")
        fetchRequest.fetchLimit = 1
        
        let objects = try context.fetch(fetchRequest)
        
        if let foundObject = objects.first {
            return foundObject
        } else {
            throw NSError.create(with: RepositoryErrorNotFound)
        }
    }
    
    open func get<T: NSManagedObject>(with predicate: NSPredicate) throws -> [T] {
        let fetchRequest: NSFetchRequest<T> = try createFetchRequest()
        fetchRequest.predicate = predicate
        
        return try context.fetch(fetchRequest)
    }

    open func save(_ policy: UpdatePolicy = .all) async throws {
        try await context.perform { [weak self] in
            self?.context.mergePolicy = policy.toCoreData()
            
            try self?.context.save()
        }
    }
    
    open func delete<T: NSManagedObject>(_ item: T) async throws{
        try await context.perform { [weak self] in
            self?.context.delete(item)
            
            try self?.context.save()
        }
    }
    
    open func delete<T: NSManagedObject>(_ items: [T]) async throws{
        try await context.perform { [weak self] in
            items.forEach { self?.context.delete($0) }

            try self?.context.save()
        }
    }
}
