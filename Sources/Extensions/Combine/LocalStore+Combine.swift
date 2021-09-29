import Combine
import SwiftRepository

public extension LocalStoreDisk {
    
    func isExists(at URL: String) -> AnyPublisher<Bool, Never> {
        Just(URL)
            .map {
                self.isExists(at: $0)
            }
            .eraseToAnyPublisher()
    }
    
    func get(from URL: String) -> AnyPublisher<Item, Error> {
        Just(URL)
            .tryMap {
               try self.get(from: $0)
            }
            .eraseToAnyPublisher()
    }
    
    func remove(from URL: String) -> AnyPublisher<Void, Error> {
        Just(URL)
            .tryMap {
                try self.remove(from: $0)
            }
            .eraseToAnyPublisher()
    }
    
    func save(_ item: Item, at URL: String) -> AnyPublisher<Void, Error> {
        Just(URL)
            .tryMap {
                try self.save(item, at: $0)
            }
            .eraseToAnyPublisher()
    }
}
