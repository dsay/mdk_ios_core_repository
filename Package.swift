// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "mdk_ios_core_repository",
    platforms: [.iOS(.v14), .tvOS(.v9), .watchOS(.v2), .macOS(.v10_15)],
    products: [
        
        .library(
            name: "SwiftRepository",
            targets: ["SwiftRepository"]),
        
        /// Networking
        
        .library(
            name: "RequestProvider",
            targets: ["RequestProvider"]),
        
        /// LocalStore
        
        .library(
            name: "LocalStoreCodable",
            targets: ["LocalStoreCodable"]),
        
        .library(
            name: "LocalStoreCoreData",
            targets: ["LocalStoreCoreData"]),
        
        .library(
            name: "LocalStoreFileManager",
            targets: ["LocalStoreFileManager"]),
        
        .library(
            name: "LocalStoreMappable",
            targets: ["LocalStoreMappable"]),
        
        /// Core Data Persistent
        
        .library(
            name: "PersistentContainer",
            targets: ["PersistentContainer"]),
        
        /// Storage
        
        .library(
            name: "UserDefaultsStorage",
            targets: ["UserDefaultsStorage"]),
        
        .library(
            name: "KeychainSwiftStorage",
            targets: ["KeychainSwiftStorage"]),
        
        .library(
            name: "CombineExtensions",
            targets: ["CombineExtensions"]),
    ],
    dependencies: [
        .package(name: "KeychainSwift", url: "https://github.com/evgenyneu/keychain-swift.git", from: "19.0.0"),
        .package(name: "ObjectMapper", url: "https://github.com/tristanhimmelman/ObjectMapper.git", from: "4.2.0")
    ],
    targets: [
        
        .target(
            name: "SwiftRepository",
            dependencies: []),
        .testTarget(
            name: "SwiftRepositoryTests",
            dependencies: ["SwiftRepository"]),
        
        /// Networking
        
        .target(
            name: "RequestProvider",
            dependencies: [.target(name: "SwiftRepository")],
            path: "Sources/RemoteStore/RequestProvider"),
        .testTarget(
            name: "RequestProviderTests",
            dependencies: ["RequestProvider"]),
        
        /// LocalStore
        
        .target(
            name: "LocalStoreCodable",
            dependencies: [.target(name: "SwiftRepository")],
            path: "Sources/LocalStore/Codable"),
        .testTarget(
            name: "LocalStoreCodableTests",
            dependencies: ["LocalStoreCodable"]),
        
        .target(
            name: "LocalStoreMappable",
            dependencies: [.target(name: "SwiftRepository"), "ObjectMapper"],
            path: "Sources/LocalStore/Mappable"),
        .testTarget(
            name: "LocalStoreMappableTests",
            dependencies: ["LocalStoreMappable"]),
        
        .target(
            name: "LocalStoreCoreData",
            dependencies: [.target(name: "SwiftRepository")],
            path: "Sources/LocalStore/CoreData"),
        .testTarget(
            name: "LocalStoreCoreDataTests",
            dependencies: ["LocalStoreCoreData"]),
        
        .target(
            name: "LocalStoreFileManager",
            dependencies: [.target(name: "SwiftRepository")],
            path: "Sources/LocalStore/FileManager"),
        .testTarget(
            name: "LocalStoreFileManagerTests",
            dependencies: ["LocalStoreFileManager"]),
        
        .target(
            name: "PersistentContainer",
            dependencies: [],
            path: "Sources/LocalStore/PersistentContainer"),
        .testTarget(
            name: "PersistentContainerTests",
            dependencies: ["PersistentContainer"]),
        
        /// Storage
        
        .target(
            name: "UserDefaultsStorage",
            dependencies: [.target(name: "SwiftRepository")],
            path: "Sources/Storage/UserDefaults"),
        .testTarget(
            name: "UserDefaultsStorageTests",
            dependencies: ["UserDefaultsStorage"]),
        
        .target(
            name: "KeychainSwiftStorage",
            dependencies: [.target(name: "SwiftRepository"), "KeychainSwift"],
            path: "Sources/Storage/Keychain"),
        .testTarget(
            name: "KeychainSwiftStorageTests",
            dependencies: ["KeychainSwiftStorage"]),
        
        .target(
            name: "CombineExtensions",
            dependencies: [],
            path: "Sources/Extensions/Combine"),
    ]
)
