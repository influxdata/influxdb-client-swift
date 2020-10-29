//
// Created by Jakub Bednář on 20/10/2020.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@testable import InfluxDBSwift
import Mocker
import XCTest

final class InfluxDBClientTests: XCTestCase {
    private var client: InfluxDBClient?

    override func tearDown() {
        if let client = client {
            client.close()
        }
    }

    func testCreateInstance() {
        let options: InfluxDBClient.InfluxDBOptions = InfluxDBClient.InfluxDBOptions(
                bucket: "my-bucket",
                org: "my-org",
                precision: InfluxDBClient.WritePrecision.ns)

        client = InfluxDBClient(url: "http://localhost:8086", token: "my-token", options: options)
        XCTAssertNotNil(client)
    }

    func testSessionHeaders() {
        client = InfluxDBClient(
                url: "http://localhost:8086", token: "my-token", protocolClasses: [MockingURLProtocol.self])

        let onRequestExpectation = expectation(description: "Authorization and User-Agent token")

        let url = URL(string: "http://localhost:8086")!

        var mock = Mock(url: url, dataType: .json, statusCode: 204, data: [.get: Data()])
        mock.onRequest = { request, postBodyArguments in
            XCTAssertEqual(request.url?.description, "http://localhost:8086")
            XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Token my-token")
            XCTAssertEqual(
                    request.value(forHTTPHeaderField: "User-Agent"),
                    "influxdb-client-swift/\(InfluxDBClient.version)")
            onRequestExpectation.fulfill()
        }
        mock.register()

        client?.session.dataTask(with: URLRequest(url: url)).resume()
        wait(for: [onRequestExpectation], timeout: 2.0)
    }

    func testSessionHeadersV1() {
        client = InfluxDBClient(
                url: "http://localhost:8086", token: "my-token", protocolClasses: [MockingURLProtocol.self])

        let onRequestExpectation = expectation(description: "Authorization and User-Agent token")

        let url = URL(string: "http://localhost:8086")!

        var mock = Mock(url: url, dataType: .json, statusCode: 204, data: [.get: Data()])
        mock.onRequest = { request, postBodyArguments in
            XCTAssertEqual(request.url?.description, "http://localhost:8086")
            XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Token my-token")
            XCTAssertEqual(
                    request.value(forHTTPHeaderField: "User-Agent"),
                    "influxdb-client-swift/\(InfluxDBClient.version)")
            onRequestExpectation.fulfill()
        }
        mock.register()

        client?.session.dataTask(with: URLRequest(url: url)).resume()
        wait(for: [onRequestExpectation], timeout: 2.0)
    }
}
