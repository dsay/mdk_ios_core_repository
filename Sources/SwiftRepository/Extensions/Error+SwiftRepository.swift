import Foundation

/*
    @discussion Constants used by NSError to differentiate between "domains" of error codes, serving as a discriminator for error codes that originate from different subsystems or sources.
    @constant RepositoryErrorDomain Indicates an SwiftRepository error.
*/

public let RepositoryErrorDomain = "SwiftRepositoryError"

/*!
    @enum Repository-related Error Codes
    @abstract Constants used by NSError to indicate errors in the RepositoryError domain
*/

public let RepositoryErrorUnknown = RepositoryErrorCode(rawValue: 2000)

public let RepositoryErrorNotFound = RepositoryErrorCode(rawValue: 2001)
public let RepositoryErrorBadURL = RepositoryErrorCode(rawValue: 2002)
public let RepositoryErrorManagedObjectContextNotFound = RepositoryErrorCode(rawValue: 2003)
public let RepositoryErrorKeyPathNotFound = RepositoryErrorCode(rawValue: 2004)


public struct RepositoryErrorCode: RawRepresentable, Equatable, Hashable, Sendable {

    /// The raw type that can be used to represent all values of the conforming
    /// type.
    ///
    /// Every distinct value of the conforming type has a corresponding unique
    /// value of the `RawValue` type, but there may be values of the `RawValue`
    /// type that don't have a corresponding value of the conforming type.
    public typealias RawValue = Int

    /// The key's string value.
    public let rawValue: Int

    /// Creates a new instance with the given raw value.
    ///
    /// - parameter rawValue: The value of the key.
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    /// Returns a Boolean value indicating whether the given keys are equal.
    ///
    /// - parameter lhs: The key to compare against.
    /// - parameter rhs: The key to compare with.
    public static func == (lhs: RepositoryErrorCode, rhs: RepositoryErrorCode) -> Bool {
        rhs.rawValue == lhs.rawValue
    }

    /// Hashes the essential components of this value by feeding them into the
    /// given hasher.
    ///
    /// - Parameter hasher: The hasher to use when combining the components
    ///   of this instance.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

extension NSError {
    
    static public func create(with code: Int, message: String) -> NSError {
        let userInfo: [String: Any] = [NSLocalizedDescriptionKey: message]
        
        return NSError(domain: RepositoryErrorDomain, code: code, userInfo: userInfo)
    }
    
    static public func create(with code: RepositoryErrorCode) -> NSError {
        let userInfo: [String: Any] = [NSLocalizedDescriptionKey: code.message]
        
        return NSError(domain: RepositoryErrorDomain, code: code.rawValue, userInfo: userInfo)
    }
}

extension RepositoryErrorCode {
    
    public var message: String {
        switch rawValue {
   
        case RepositoryErrorNotFound.rawValue:
            return "Not found"
            
        case RepositoryErrorBadURL.rawValue:
            return "Bad URL"
            
        case RepositoryErrorManagedObjectContextNotFound.rawValue:
            return "ManagedObjectContext not found in JSONDecoder"
            
        case RepositoryErrorKeyPathNotFound.rawValue:
            return "Nested json not found for key path"
            
        default:
            return "Unexpected error"
        }
    }
}
