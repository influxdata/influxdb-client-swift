//
// Created by Jakub Bednář on 20/10/2020.
//

@testable import InfluxDBSwift
import XCTest

final class InfluxDBClientTests: XCTestCase {
    func testCreateInstance() {
        let options: InfluxDBClient.InfluxDBOptions = InfluxDBClient.InfluxDBOptions(
                bucket: "my-bucket",
                org: "my-org",
                precision: InfluxDBClient.WritePrecision.ns)

        let client = InfluxDBClient(url: "http://localhost:8086", token: "my-token", options: options)
        XCTAssertNotNil(client)

        client.close()
    }
}
