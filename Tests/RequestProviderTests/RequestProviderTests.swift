import XCTest
@testable import RequestProvider

final class RequestProviderTests: XCTestCase {
    
    func testURL() throws {
        let request1 = try TestRequest(url: "https://test.com").asURLRequest()
        XCTAssertEqual(request1.url?.absoluteString, "https://test.com")
        
        let request2 = try TestRequest(url: "https://test.com/").asURLRequest()
        XCTAssertEqual(request2.url?.absoluteString, "https://test.com")
        
        do {
            _ = try TestRequest(url: "").asURLRequest()
            XCTFail("Request not valid")
        } catch {
            XCTPass()
        }
    }
    
    func testMethod() throws {
        let get = try TestRequest(method: .get).asURLRequest()
        XCTAssertEqual(get.httpMethod, "GET")

        let post = try TestRequest(method: .post).asURLRequest()
        XCTAssertEqual(post.httpMethod, "POST")
        
        let put = try TestRequest(method: .put).asURLRequest()
        XCTAssertEqual(put.httpMethod, "PUT")

        let delete = try TestRequest(method: .delete).asURLRequest()
        XCTAssertEqual(delete.httpMethod, "DELETE")

        let connect = try TestRequest(method: .connect).asURLRequest()
        XCTAssertEqual(connect.httpMethod, "CONNECT")

        let patch = try TestRequest(method: .patch).asURLRequest()
        XCTAssertEqual(patch.httpMethod, "PATCH")
    }
    
    func testPathString() throws {
        let request = try TestRequest(path: "test/test").asURLRequest()
        XCTAssertEqual(request.url?.absoluteString, "https://test.com/test/test")

        let request1 = try TestRequest(path: "/test/test").asURLRequest()
        XCTAssertEqual(request1.url?.absoluteString, "https://test.com/test/test")

        let request2 = try TestRequest(path: "").asURLRequest()
        XCTAssertEqual(request2.url?.absoluteString, "https://test.com")

        let request3 = try TestRequest(path: "?").asURLRequest()
        XCTAssertEqual(request3.url?.absoluteString, "https://test.com/%3F")
    }
    
    func testPathArray() throws {
        let request = try TestRequest(path: ["test", "test"]).asURLRequest()
        XCTAssertEqual(request.url?.absoluteString, "https://test.com/test/test")

        let request1 = try TestRequest(path: ["/test", "/test"]).asURLRequest()
        XCTAssertEqual(request1.url?.absoluteString, "https://test.com/test/test")

        let request2 = try TestRequest(path: ["/test", ""]).asURLRequest()
        XCTAssertEqual(request2.url?.absoluteString, "https://test.com/test")

        let request3 = try TestRequest(path: ["test", "?"]).asURLRequest()
        XCTAssertEqual(request3.url?.absoluteString, "https://test.com/test/%3F")
    }
    
    func testPath() throws {
        let request = try TestRequest(path: "test"/"test"/"test").asURLRequest()
        XCTAssertEqual(request.url?.absoluteString, "https://test.com/test/test/test")

        let request2 = try TestRequest(path: "test"/""/"test").asURLRequest()
        XCTAssertEqual(request2.url?.absoluteString, "https://test.com/test/test")

        let request3 = try TestRequest(path: "test"/"?").asURLRequest()
        XCTAssertEqual(request3.url?.absoluteString, "https://test.com/test/%3F")
        
        let request4 = try TestRequest(url: "https://test.com/test", path: "test"/"?").asURLRequest()
        XCTAssertEqual(request4.url?.absoluteString, "https://test.com/test/test/%3F")
    }
    
    func testHeader() throws {
        let request = try TestRequest(headers: ["key": "value"]).asURLRequest()
        let value = request.allHTTPHeaderFields?["key"]
        XCTAssertEqual(value, "value")
    }
    
    func testQuery() throws {
        let request = try TestRequest(query: ["key": "value"]).asURLRequest()
        XCTAssertEqual(request.url?.absoluteString, "https://test.com?key=value")
        
        let request1 = try TestRequest(query: [:]).asURLRequest()
        XCTAssertEqual(request1.url?.absoluteString, "https://test.com")
        
        let request2 = try TestRequest(query: ["key": nil]).asURLRequest()
        XCTAssertEqual(request2.url?.absoluteString, "https://test.com?key")
        
        let request3 = try TestRequest(query: ["key": ""]).asURLRequest()
        XCTAssertEqual(request3.url?.absoluteString, "https://test.com?key=")
        
        let request4 = try TestRequest(query: ["key": "&"]).asURLRequest()
        XCTAssertEqual(request4.url?.absoluteString, "https://test.com?key=%2526")
        
        let request5 = try TestRequest(url: "https://test.com?key=value", query: ["key1": "&"]).asURLRequest()
        XCTAssertEqual(request5.url?.absoluteString, "https://test.com?key1=%2526&key=value")
    }
    
    func testNoneBody() throws {
        let request = try TestRequest(body: .none).asURLRequest()
        XCTAssertEqual(request.httpBody, nil)
    }
    
    func testJSONBody() throws {
        let request = try TestRequest(body: .json(["key": "value"])).asURLRequest()
        
        guard let data = request.httpBody else {
            XCTFail()
            return
        }
       
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let value = json["key"] as? String
        {
            XCTAssertEqual(value, "value")
        } else {
            XCTFail()
        }
        
        let value = request.allHTTPHeaderFields?["Content-Type"]
        XCTAssertEqual(value, "application/json")
    }
    
    func testURLBody() throws {
        let request = try TestRequest(body: .url(["string": "value", "bool": "1", "number": 1, "array": ["1", "2"], "dict": ["val1": "val"]])).asURLRequest()
        
        guard let data = request.httpBody else {
            XCTFail()
            return
        }
        
        if let body = String(data: data, encoding: .utf8) {
            XCTAssertEqual(body, "array%5B%5D=1&array%5B%5D=2&bool=1&dict%5Bval1%5D=val&number=1&string=value")
        } else {
            XCTFail()
        }
        
        let value = request.allHTTPHeaderFields?["Content-Type"]
        XCTAssertEqual(value, "application/x-www-form-urlencoded")
    }
    
    static var allTests = [
        ("testURL", testURL),
        ("testMethod", testMethod),
        ("testPathString", testPathString),
        ("testPathArray", testPathArray),
        ("testPath", testPath),
        ("testHeader", testHeader),
        ("testNoneBody", testNoneBody),
        ("testJSONBody", testJSONBody),
        ("testURLBody", testURLBody),
    ]
}

extension XCTestCase {
    
    func XCTPass() {
        XCTAssertTrue(true)
    }
}
