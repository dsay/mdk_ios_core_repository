import CoreData
import Foundation
import SwiftRepository

open class Database {
    
    public let container: NSPersistentContainer

    private var coordinator: NSPersistentStoreCoordinator { container.persistentStoreCoordinator }

    public init(name: String) {
        self.container = NSPersistentContainer(name: name)
    }
    
    open func addStores(_ descriptions: [NSPersistentStoreDescription]) async throws {
        try await withCheckedThrowingContinuation({ continuation in
            addStores(descriptions) { result in
                switch result {
                case .success:
                    continuation.resume()
                    
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        })
    }
    
    private func addStores(_ descriptions: [NSPersistentStoreDescription], _ completionHandler: @escaping (Result<Void, Error>) -> Void) {
        
        var completed: [Error?] = []
        
        container.persistentStoreDescriptions = descriptions
        container.loadPersistentStores(completionHandler: { [weak self] description, error in
            guard let self = self else { return }

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

extension Result where Success == Void {
    
    public static func success() -> Self { .success(()) }
}
