import Foundation
import SwiftRepository

public protocol RequestLogger {
    
    func start()
    func finish()
    func logRetry(after error: Error)
    func log(_ request: URLRequest)
    func log(_ result: HttpResult)
    func log(_ error: Error)
}

public struct DefaultLogger: RequestLogger {

    let separator = " "
    let empty = "----"
    
    public init(){}
    
    public func start() {
        divider()
    }
    
    public func finish() {
        divider()
    }
    
    public func logRetry(after error: Error) {
        log(error)
        print("📙 Retry", separator: separator)
    }
    
    public func log(_ request: URLRequest) {
        methodName(request.httpMethod)
        urlPath(request.url?.absoluteString)
        header(request.allHTTPHeaderFields)
        parameters(request.httpBody)
    }
    
    public func log(_ result: HttpResult) {
        statusCode(result.response)
        success(result.data)
   }
    
    public func log(_ error: Error) {
        switch error {
        case let error as NSError:
            print("📕 StatusCode:", error.code, separator: separator)
            
        default: ()
        }
        
        print("📕 Failure:", error.localizedDescription, separator: separator)
    }
    
    fileprivate func statusCode(_ response: URLResponse) {
        guard let response = response as? HTTPURLResponse else {
            print("📙 StatusCode:", empty, separator: separator)
            return
        }
        
        print("📗 StatusCode:", response.statusCode, separator: separator)
    }
    
    fileprivate func success(_ data: Data) {
        let string = data.prettyPrintedJSONString ?? ""
        print("📗 Success:", string, separator: separator)
    }
    
    private func divider(_ symols: Int = 60) {
        print((0 ... symols).compactMap { _ in return "-" }.reduce("", { divider, add -> String in
            return divider + add
        }))
    }
    
    fileprivate func methodName(_ name: String?) {
        if let name = name {
            print("📘 Method:", name, separator: separator)
        } else {
            print("📓 Method:", empty, separator: separator)
        }
    }
    
    fileprivate func urlPath(_ path: String?) {
        if let path = path {
            print("📘 URL:", path, separator: separator)
        } else {
            print("📓 URL:", empty, separator: separator)
        }
    }
    
    fileprivate func header(_ header: [String: String]?) {
        if let header = header, header.isEmpty == false {
            
            let string = header.compactMap {
                "\($0): \($1)"
            }.joined(separator: "\n           ")
            
            print("📘 Header:", string, separator: separator)
        } else {
            print("📓 Header:", empty, separator: separator)
        }
    }
    
    fileprivate func parameters(_ data: Data?) {
        if let parameters = data.flatMap({ $0.prettyPrintedJSONString }) {
            print("📘 Parameters:", parameters, separator: separator)
        } else {
            print("📓 Parameters:", empty, separator: separator)
        }
    }
}

public struct ProductionLogger: RequestLogger {

    public init(){}
    
    public func start() {}
    
    public func finish() {}
    
    public func logRetry(after error: Error) {}

    public func log(_ request: URLRequest) {}
    
    public func log(_ result: HttpResult) {}
    
    public func log(_ error: Error) {}
}

extension Data {
    
    var prettyPrintedJSONString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = String(data: data, encoding: .utf8) else
        {
            return String(data: self, encoding: .utf8)
        }
        
        return prettyPrintedString
    }
}
