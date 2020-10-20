//
// Created by Jakub Bednář on 20/10/2020.
//

@testable import influxdb_client_swift
import XCTest

final class InfluxDBClientTests: XCTestCase {
    func testCreateInstance() {
        XCTAssertNil(InfluxDBClient())
    }

    static var allTests = [
        ("testCreateInstance", testCreateInstance)
    ]
}
