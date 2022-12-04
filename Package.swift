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
                name: "RemoteStoreURLSession",
                targets: ["RemoteStoreURLSession"]),
        
        /// LocalStore
        
            .library(
                name: "LocalStoreCoreData",
                targets: ["LocalStoreCoreData"]),
        
            .library(
                name: "LocalStoreFileManager",
                targets: ["LocalStoreFileManager"]),
        
            .library(
                name: "LocalStoreUserDefaults",
                targets: ["LocalStoreUserDefaults"]),
        
            .library(
                name: "LocalStoreKeychain",
                targets: ["LocalStoreKeychain"]),
    ],
    dependencies: [
        .package(name: "KeychainSwift", url: "https://github.com/evgenyneu/keychain-swift.git", from: "19.0.0"),
    ],
    targets: [
        
        .target(
            name: "SwiftRepository",
            dependencies: []),
        
        /// Networking
        
            .target(
                name: "RemoteStoreURLSession",
                dependencies: [.target(name: "SwiftRepository")],
                path: "Sources/RemoteStore"),

        /// LocalStore
        
            .target(
                name: "LocalStoreCoreData",
                dependencies: [.target(name: "SwiftRepository")],
                path: "Sources/LocalStore/CoreData"),

            .target(
                name: "LocalStoreKeychain",
                dependencies: [.target(name: "SwiftRepository"), "KeychainSwift"],
                path: "Sources/LocalStore/Keychain"),
   
            .target(
                name: "LocalStoreUserDefaults",
                dependencies: [.target(name: "SwiftRepository")],
                path: "Sources/LocalStore/UserDefaults"),
  
            .target(
                name: "LocalStoreFileManager",
                dependencies: [.target(name: "SwiftRepository")],
                path: "Sources/LocalStore/FileManager"),
    ]
)
