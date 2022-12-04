import Foundation
import CoreData

extension JSONDecoder {
    
    public func setManagedObjectContext(_ context: NSManagedObjectContext) {
        userInfo[.managedObjectContext] = context
    }
}

extension Decoder {
    
    public func getManagedObjectContext() throws -> NSManagedObjectContext {
        guard let context = userInfo[.managedObjectContext] as? NSManagedObjectContext else {
            throw NSError.create(with: RepositoryErrorManagedObjectContextNotFound)
        }
        return context
    }
}

extension CodingUserInfoKey {
    
    static public let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}
