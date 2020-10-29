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
        client = InfluxDBClient(url: "http://localhost:8086", token: "my-token")

        let headers: [String: String] = client?.session.configuration.httpAdditionalHeaders as? [String: String] ?? [:]
        XCTAssertEqual("Token my-token", headers["Authorization"])
        XCTAssertEqual("influxdb-client-swift/\(InfluxDBClient.version)", headers["User-Agent"])
    }

    func testSessionHeadersV1() {
        client = InfluxDBClient(
                url: "http://localhost:8086",
                username: "user",
                password: "pass",
                database: "my-db",
                retentionPolicy: "autogen")

        let headers: [String: String] = client?.session.configuration.httpAdditionalHeaders as? [String: String] ?? [:]
        XCTAssertEqual("Token user:pass", headers["Authorization"])
        XCTAssertEqual("influxdb-client-swift/\(InfluxDBClient.version)", headers["User-Agent"])

        XCTAssertEqual(client?.options.bucket, "my-db/autogen")
    }
}
