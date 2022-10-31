import Combine
//import SwiftRepository
//
//extension Result {
//
//    var publisher: AnyPublisher<Success, Failure> {
//        Future { promise in
//            switch self {
//            case .success(let value):
//                promise(.success(value))
//            case .failure(let error):
//                promise(.failure(error))
//            }
//        }.eraseToAnyPublisher()
//    }
//}
//
//extension Publisher where Output: Sequence {
//    typealias Sorter = (Output.Element, Output.Element) -> Bool
//
//    func sort( by sorter: @escaping Sorter) -> Publishers.Map<Self, [Output.Element]> {
//        map { sequence in
//            sequence.sorted(by: sorter)
//        }
//    }
//}
//
//public extension Publisher {
//
//    func get(_ transform: @escaping (Output) -> Void) -> Publishers.Map<Self, Output> {
//        map {
//            transform($0)
//            return $0
//        }
//    }
//
//    func toVoid() -> Publishers.Map<Self, Void>  {
//        map { _ in return () }
//    }
//}
//
//public extension Publisher where Output: Collection {
//
//    func get(_ transform: @escaping (Output) -> Void) -> Publishers.Map<Self, Output> {
//        map {
//            transform($0)
//            return $0
//        }
//    }
//
//    func mapElement<Result>(_ transform: @escaping (Output.Element) -> Result) -> Publishers.Map<Self, [Result]> {
//        map { $0.map(transform) }
//    }
//
//    func getElement(_ transform: @escaping (Output.Element) -> Void) -> Publishers.Map<Self, Output> {
//        map {
//            $0.forEach(transform)
//            return $0
//        }
//    }
//}
//
//public extension Publisher where Output: Collection, Failure == RepositoryError {
//
//    func first(_ transform: @escaping (Output.Element) -> Bool) -> Publishers.TryMap<Self, Output.Element> {
//        tryMap {
//            if let first = $0.first(where: transform) {
//                return first
//            } else {
//                throw RepositoryError.notFound
//            }
//        }
//    }
//}
//
//extension Publisher {
//
//    func done(ensure: (() -> Void)? = nil,
//              receiveError: ((Self.Failure) -> Void)? = nil,
//              receiveValue: ((Self.Output) -> Void)? = nil) -> AnyCancellable {
//        sink { completion in
//            if case let .failure(error) = completion {
//                receiveError?(error)
//            }
//            ensure?()
//        } receiveValue: { value in
//            receiveValue?(value)
//        }
//    }
//}
