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
