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

open class LocalStoreCoreData<Item: NSManagedObject>: LocalStoreDataBase {

    public let context: NSManagedObjectContext

    public init(_ context: NSManagedObjectContext) {
        self.context = context
    }

    open func createFetchRequest() throws -> NSFetchRequest<Item> {
        guard let name = Item.entity().name else {
            throw RepositoryError.notFound
        }
        
        return NSFetchRequest(entityName: name)
    }
    
    open func getItem(response: @escaping (Result<Item, RepositoryError>) -> Void) {
        do {
            let fetchRequest = try createFetchRequest()
            fetchRequest.fetchLimit = 1
            
            let objects = try context.fetch(fetchRequest)
            
            if let foundObject = objects.first {
                response(.success(foundObject))
            } else {
                response(.failure(.notFound))
            }
        } catch {
            response(.failure(.error(error)))
        }
    }

    open func getItems(response: @escaping (Result<[Item], RepositoryError>) -> Void) {
        do {
            let fetchRequest = try createFetchRequest()
            
            let objects = try context.fetch(fetchRequest)
            
            response(.success(objects))
        } catch {
            response(.failure(.error(error)))
        }
    }

    open func get(with id: Int, response: @escaping (Result<Item, RepositoryError>) -> Void) {
        do {
            let fetchRequest = try createFetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            fetchRequest.fetchLimit = 1
            
            let objects = try context.fetch(fetchRequest)
            
            if let foundObject = objects.first {
                response(.success(foundObject))
            } else {
                response(.failure(.notFound))
            }
        } catch {
            response(.failure(.error(error)))
        }
    }

    open func get(with id: String, response: @escaping (Result<Item, RepositoryError>) -> Void) {
        do {
            let fetchRequest = try createFetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            fetchRequest.fetchLimit = 1
            
            let objects = try context.fetch(fetchRequest)
            
            if let foundObject = objects.first {
                response(.success(foundObject))
            } else {
                response(.failure(.notFound))
            }
        } catch {
            response(.failure(.error(error)))
        }
    }
    
    open func get(with predicate: NSPredicate, response: @escaping (Result<[Item], RepositoryError>) -> Void) {
        do {
            let fetchRequest = try createFetchRequest()
            fetchRequest.predicate = predicate
            
            let objects = try context.fetch(fetchRequest)
            
            response(.success(objects))
        } catch {
            response(.failure(.error(error)))
        }
    }

    open func update(_ write: @escaping () -> Void, response: @escaping (Result<Void, RepositoryError>) -> Void) {
        context.perform {
            write()
            
            do {
                try self.context.save()
            } catch {
                response(.failure(.error(error)))
            }
        }
    }

    open func save(_ item: Item, policy: UpdatePolicy = .all, response: @escaping (Result<Void, RepositoryError>) -> Void) {
        context.perform {
            self.context.mergePolicy = policy.toCoreData()
            
            do {
                try self.context.save()
            } catch {
                response(.failure(.error(error)))
            }
        }
    }
    
    open func save(_ items: [Item], policy: UpdatePolicy = .all, response: @escaping (Result<Void, RepositoryError>) -> Void) {
        context.perform {
            self.context.mergePolicy = policy.toCoreData()
            
            do {
                try self.context.save()
            } catch  {
                response(.failure(.error(error)))
            }
        }
    }
    
    open func remove(_ item: Item, response: @escaping (Result<Void, RepositoryError>) -> Void) {
        context.perform {
            self.context.delete(item)
            
            do {
                try self.context.save()
            } catch {
                response(.failure(.error(error)))
            }
        }
    }

    open func remove(_ items: [Item], response: @escaping (Result<Void, RepositoryError>) -> Void) {
        context.perform {
            items.forEach { self.context.delete($0) }
            
            do {
                try self.context.save()
            } catch {
                response(.failure(.error(error)))
            }
        }
    }
}
