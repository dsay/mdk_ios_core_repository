import Foundation
import SwiftRepository

public typealias HttpResult = (data: Data, response: URLResponse)

open class RemoteStoreURLSession {
    
    // MARK: - Properties
    
    public let session: URLSession
    
    public let logger: RequestLogger
    public let adapter: RequestAdapter
    public let retrier: RequestRetrier
    public let handler: ResponseHandler
    
    // MARK: - Lifecycle
    
    public init(session: URLSession,
                logger: RequestLogger = DefaultLogger(),
                adapter: RequestAdapter = DefaultRequestAdapter(),
                retrier: RequestRetrier = DefaultRequestRetrier(),
                handler: ResponseHandler = DefaultHandler())
    {
        self.session = session
        self.logger = logger
        self.adapter = adapter
        self.retrier = retrier
        self.handler = handler
    }
    
    // MARK: - Methods
    open func buildRequest(for provider: RequestProvider) async throws -> URLRequest {
        let request = try provider.asURLRequest()
        
        return try await adapter.adapt(request, session: session)
    }
    
    open func data(for request: URLRequest, isRetried: Bool = false) async throws -> HttpResult {
        do {
            let result: HttpResult = try await session.data(for: request)
            
            return try handler.handle(result: result)
        } catch {
            guard isRetried == false else {
                throw error
            }
            
            return try await retry(for: request, error: error)
        }
    }
    
    open func retry(for request: URLRequest, error: Error) async throws -> HttpResult {
        let result = try await retrier.retry(request, session: session, error: error)
        
        switch result {
        case .retry:
            logger.logRetry(after: error)
            
            return try await data(for: request, isRetried: true)
            
        case .retryWithDelay(let timeInterval):
            logger.logRetry(after: error)
            
            try await Task.sleep(timeInterval)
            return try await data(for: request, isRetried: true)
            
        case .doNotRetry:
            throw error
        }
    }
}

extension RemoteStoreURLSession: RemoteStore {
    
    // MARK: - RemoteStore methods
    public func dataRequest(for provider: RequestProvider) async throws -> Data {
        logger.start()
        
        defer {
            logger.finish()
        }
        
        do {
            let request = try await buildRequest(for: provider)
            
            logger.log(request)
            
            let result = try await data(for: request)
            
            logger.log(result)
            
            return result.data
            
        } catch {
            logger.log(error)
            
            throw error
        }
    }
    
    public func stringRequest(for provider: RequestProvider) async throws -> String {
        logger.start()
        
        defer {
            logger.finish()
        }
        
        do {
            let request = try await buildRequest(for: provider)
            
            logger.log(request)
            
            let result = try await data(for: request)
            
            logger.log(result)
            
            return String(data: result.data, encoding: .utf8) ?? ""
            
        } catch {
            logger.log(error)
            
            throw error
        }
    }
    
    public func jsonRequest(for provider: RequestProvider, keyPath: String? = nil) async throws -> Any {
        logger.start()
        
        defer {
            logger.finish()
        }
        
        do {
            let request = try await buildRequest(for: provider)
            
            logger.log(request)
            
            let result = try await data(for: request)
            
            logger.log(result)
            
            return try JSONSerialization.jsonObject(with: result.data, options: [], keyPath: keyPath)
            
        } catch  {
            logger.log(error)
            
            throw error
        }
    }
    
    public func objectRequest<T: Decodable>(for provider: RequestProvider,
                                          keyPath: String? = nil,
                                          decoder: JSONDecoder = JSONDecoder()) async throws -> T
    {
        logger.start()
        
        defer {
            logger.finish()
        }
        
        do {
            let request = try await buildRequest(for: provider)
            
            logger.log(request)
            
            let result = try await data(for: request)
            
            logger.log(result)
            
            return try decoder.decode(T.self, from: result.data, keyPath: keyPath)
            
        } catch  {
            logger.log(error)
            
            throw error
        }
    }
    
    public func objectsRequest<T: Decodable>(for provider: RequestProvider,
                                           keyPath: String? = nil,
                                           decoder: JSONDecoder = JSONDecoder()) async throws -> [T]
    {
        logger.start()
        
        defer {
            logger.finish()
        }
        
        do {
            let request = try await buildRequest(for: provider)
            
            logger.log(request)
            
            let result = try await data(for: request)
            
            logger.log(result)
            
            return try decoder.decode([T].self, from: result.data, keyPath: keyPath)
            
        } catch  {
            logger.log(error)
            
            throw error
        }
    }
}
