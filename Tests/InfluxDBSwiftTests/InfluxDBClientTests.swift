//
// Created by Jakub Bednář on 20/10/2020.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@testable import InfluxDBSwift
import XCTest

final class InfluxDBClientTests: XCTestCase {
    private var client: InfluxDBClient!

    override func tearDown() {
        client.close()
    }

    func testCreateInstance() {
        let options: InfluxDBClient.InfluxDBOptions = InfluxDBClient.InfluxDBOptions(
                bucket: "my-bucket",
                org: "my-org",
                precision: .ns)

        client = InfluxDBClient(url: Self.dbURL(), token: "my-token", options: options)
        XCTAssertNotNil(client)
    }

    func testSessionHeaders() {
        client = InfluxDBClient(url: Self.dbURL(), token: "my-token")

        let headers: [String: String] = client.session.configuration.httpAdditionalHeaders as? [String: String] ?? [:]
        XCTAssertEqual("Token my-token", headers["Authorization"])
        XCTAssertEqual("influxdb-client-swift/\(InfluxDBClient.version)", headers["User-Agent"])
    }

    func testSessionHeadersV1() {
        client = InfluxDBClient(
                url: Self.dbURL(),
                username: "user",
                password: "pass",
                database: "my-db",
                retentionPolicy: "autogen")

        let headers: [String: String] = client.session.configuration.httpAdditionalHeaders as? [String: String] ?? [:]
        XCTAssertEqual("Token user:pass", headers["Authorization"])
        XCTAssertEqual("influxdb-client-swift/\(InfluxDBClient.version)", headers["User-Agent"])

        XCTAssertEqual("my-db/autogen", client.options.bucket)
    }

    func testTimeoutDefault() {
        client = InfluxDBClient(url: Self.dbURL(), token: "my-token")
        XCTAssertEqual(60, client.session.configuration.timeoutIntervalForRequest)
        XCTAssertEqual(300, client.session.configuration.timeoutIntervalForResource)
    }

    func testTimeoutConfigured() {
        let options: InfluxDBClient.InfluxDBOptions = InfluxDBClient.InfluxDBOptions(
                timeoutIntervalForRequest: 100,
                timeoutIntervalForResource: 5000)

        client = InfluxDBClient(url: Self.dbURL(), token: "my-token", options: options)
        XCTAssertEqual(100, client.session.configuration.timeoutIntervalForRequest)
        XCTAssertEqual(5000, client.session.configuration.timeoutIntervalForResource)
    }

    func testBaseURL() {
        client = InfluxDBClient(url: Self.dbURL(), token: "my-token")
        XCTAssertEqual(Self.dbURL(), client.url)
        client.close()
        client = InfluxDBClient(url: Self.dbURL(), token: "my-token")
        XCTAssertEqual(Self.dbURL(), client.url)
        client.close()
    }

    func testConfigureProxy() {
        #if os(macOS)
        var connectionProxyDictionary = [AnyHashable: Any]()
        connectionProxyDictionary[kCFNetworkProxiesHTTPEnable as String] = 1
        connectionProxyDictionary[kCFNetworkProxiesHTTPProxy as String] = "localhost"
        connectionProxyDictionary[kCFNetworkProxiesHTTPPort as String] = 3128

        let options: InfluxDBClient.InfluxDBOptions = InfluxDBClient.InfluxDBOptions(
                bucket: "my-bucket",
                org: "my-org",
                precision: .ns,
                connectionProxyDictionary: connectionProxyDictionary)

        client = InfluxDBClient(url: "http://localhost:8086", token: "my-token", options: options)
        #endif
    }

    func testFollowRedirect() {
        client = InfluxDBClient(
                url: Self.dbURL(),
                token: "my-token",
                options: InfluxDBClient.InfluxDBOptions(bucket: "my-bucket", org: "my-org"),
                protocolClasses: [MockURLProtocol.self])

        let expectation = self.expectation(description: "Success response from API doesn't arrive")
        expectation.expectedFulfillmentCount = 3

        MockURLProtocol.handler = { request, _ in
            XCTAssertEqual("Token my-token", request.allHTTPHeaderFields!["Authorization"])

            expectation.fulfill()

            // success
            if let port = request.url?.port, port == 8088 {
                let response = HTTPURLResponse(statusCode: 200)
                return (response, "".data(using: .utf8)!)
            }

            // redirect
            let response = HTTPURLResponse(statusCode: 307, headers: ["location": "http://localhost:8088"])
            return (response, Data())
        }

        client.queryAPI.query(query: "from ...") { _, error in
            if let error = error {
                XCTFail("Error occurs: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testDisableRedirect() {
        let expectation = self.expectation(description: "Redirect response from API doesn't arrive")
        expectation.expectedFulfillmentCount = 2

        class DisableRedirect: NSObject, URLSessionTaskDelegate {
            let expectation: XCTestExpectation

            init(_ expectation: XCTestExpectation) {
                self.expectation = expectation
            }

            func urlSession(_ session: URLSession,
                            task: URLSessionTask,
                            willPerformHTTPRedirection response: HTTPURLResponse,
                            newRequest request: URLRequest,
                            completionHandler: @escaping (URLRequest?) -> Void) {
                expectation.fulfill()
                completionHandler(nil)
            }
        }

        let options = InfluxDBClient.InfluxDBOptions(
                bucket: "my-bucket",
                org: "my-org",
                urlSessionDelegate: DisableRedirect(expectation))

        client = InfluxDBClient(
                url: Self.dbURL(),
                token: "my-token",
                options: options,
                protocolClasses: [MockURLProtocol.self])

        MockURLProtocol.handler = { request, _ in
            XCTAssertEqual("Token my-token", request.allHTTPHeaderFields!["Authorization"])

            expectation.fulfill()

            // redirect
            let response = HTTPURLResponse(statusCode: 307, headers: ["location": "http://localhost:8088"])
            return (response, Data())
        }

        client.queryAPI.query(query: "from ...") { _, _ in
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
}

final class InfluxDBErrorTests: XCTestCase {
    func testDescription() {
        XCTAssertEqual(
                "(123) Reason: generic reason, HTTP Body: [\"message\": \"fail\"], HTTP Headers: [\"key\": \"value\"]",
                InfluxDBClient.InfluxDBError.error(
                        123,
                        ["key": "value"],
                        ["message": "fail"],
                        InfluxDBClient.InfluxDBError.generic("generic reason")
                ).description)
        XCTAssertEqual("generic message", InfluxDBClient.InfluxDBError.generic("generic message").description)
    }
}

extension XCTestCase {
    internal static func dbURL() -> String {
        if let url = ProcessInfo.processInfo.environment["INFLUXDB_URL"] {
            return url
        }
        return "http://localhost:8086"
    }
}
