import Combine
import SwiftRepository
import Foundation

public extension RemoteStore {
    
    func send(request: RequestProvider) -> AnyPublisher<String, Error> {
        Future { promise in
            self.send(request: request, responseString: { (result: Result<String, Error>) in
                switch result {
                case .success(let value):
                    promise(.success(value))
                case .failure(let error):
                    promise(.failure(error))
                }
            })
        }.eraseToAnyPublisher()
    }
    
    func send(request: RequestProvider) -> AnyPublisher<Data, Error> {
        Future { promise in
            self.send(request: request, responseData: { (result: Result<Data, Error>) in
                switch result {
                case .success(let value):
                    promise(.success(value))
                case .failure(let error):
                    promise(.failure(error))
                }
            })
        }.eraseToAnyPublisher()
    }
    
    func send(request: RequestProvider) -> AnyPublisher<Any, Error> {
        Future { promise in
            self.send(request: request, responseJSON: { (result: Result<Any, Error>) in
                switch result {
                case .success(let value):
                    promise(.success(value))
                case .failure(let error):
                    promise(.failure(error))
                }
            })
        }.eraseToAnyPublisher()
    }
    
}

public extension RemoteStoreObjects {
    
    func send(request: RequestProvider, keyPath: String?) -> AnyPublisher<Item, Error> {
        Future { promise in
            self.send(request: request, keyPath: keyPath, responseObject: { (result: Result<Item, Error>) in
                switch result {
                case .success(let value):
                    promise(.success(value))
                case .failure(let error):
                    promise(.failure(error))
                }
            })
        }.eraseToAnyPublisher()
    }
    
    func send(request: RequestProvider, keyPath: String?) -> AnyPublisher<[Item], Error> {
        Future { promise in
            self.send(request: request, keyPath: keyPath, responseArray: { (result: Result<[Item], Error>) in
                switch result {
                case .success(let value):
                    promise(.success(value))
                case .failure(let error):
                    promise(.failure(error))
                }
            })
        }.eraseToAnyPublisher()
    }
}
