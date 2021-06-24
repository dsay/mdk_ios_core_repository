import Foundation

public protocol Storage {

    func setString(_ string: String, forKey key: String)
    func setData(_ data: Data, forKey key: String)
    func setBool(_ bool: Bool, forKey key: String)

    func getData(_ key: String) -> Data?
    func getString(_ key: String) -> String?
    func getBool(_ key: String, defaultValue: Bool) -> Bool
    
    func deleteValue(_ key: String)
}
