import Foundation
import SwiftRepository

public struct JSONBodyConverter: RequestComposer {
    
    public typealias Parameters = [String: Any]

    var parameters: Parameters?
    
    public init(json: Parameters?) {
        self.parameters = json
    }
    
    public func compose(into request: URLRequest) throws -> URLRequest {
        var request = request

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      
        guard let bodyParameters = parameters else { return request }
        
        let data = try JSONSerialization.data(withJSONObject: bodyParameters, options: [])
        request.httpBody = data
        return request
    }
}

public struct URLBodyConverter: RequestComposer {
    
    public typealias Parameters = [String: Any]

    public let arrayEncoding: ArrayEncoding = .brackets
    public let boolEncoding: BoolEncoding = .numeric
    
    public enum ArrayEncoding {
        case brackets
        case noBrackets

        func encode(key: String) -> String {
            switch self {
            case .brackets:
                return "\(key)[]"
            case .noBrackets:
                return key
            }
        }
    }

    public enum BoolEncoding {
        case numeric
        case literal

        func encode(value: Bool) -> String {
            switch self {
            case .numeric:
                return value ? "1" : "0"
            case .literal:
                return value ? "true" : "false"
            }
        }
    }
    
    var parameters: Parameters?
    
    public init(parameters: Parameters?) {
        self.parameters = parameters
    }
    
    public func compose(into request: URLRequest) throws -> URLRequest {
        var request = request
        
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        guard let bodyParameters = parameters else { return request }

        request.httpBody = Data(query(bodyParameters).utf8)

        return request
    }
    
    private func query(_ parameters: [String: Any]) -> String {
          var components: [(String, String)] = []

          for key in parameters.keys.sorted(by: <) {
              let value = parameters[key]!
              components += queryComponents(fromKey: key, value: value)
          }
          return components.map { "\($0)=\($1)" }.joined(separator: "&")
      }
    
    public func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        
        switch value {
        case let dictionary as [String: Any]:
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        case let array as [Any]:
            for value in array {
                components += queryComponents(fromKey: arrayEncoding.encode(key: key), value: value)
            }
            
        case let value as NSNumber where value.isBool:
            components.append((escape(key), escape(boolEncoding.encode(value: value.boolValue))))
            
        case let value as NSNumber:
            components.append((escape(key), escape("\(value)")))
            
        case let bool as Bool:
            components.append((escape(key), escape(boolEncoding.encode(value: bool))))
            
        default:
            components.append((escape(key), escape("\(value)")))
        }
        
        return components
    }

      public func escape(_ string: String) -> String {
          string.addingPercentEncoding(withAllowedCharacters: .URLQueryAllowed) ?? string
      }
}

extension NSNumber {
    
    fileprivate var isBool: Bool {
        String(cString: objCType) == "c"
    }
}
