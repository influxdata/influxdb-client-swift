//
// Created by Jakub Bednář on 13.10.2021.
//

import InfluxDBSwift
@testable import InfluxDBSwiftApis
import XCTest

final class PingAPITests: APIXCTestCase {
    func testPing() {
        let expectation = self.expectation(description: "Success response from API doesn't arrive")

        api.pingAPI.getPing { headers, error -> Void in
            if let error = error {
                XCTFail(error.description)
            }

            if let headers = headers {
                XCTAssertTrue(headers["X-Influxdb-Build"] != nil)
                XCTAssertTrue(headers["X-Influxdb-Version"] != nil)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    #if swift(>=5.5)
    func testPingAsync() async throws {
        let headers = try await api.pingAPI.getPing()!
        XCTAssertTrue(headers["X-Influxdb-Build"] != nil)
        XCTAssertTrue(headers["X-Influxdb-Version"] != nil)
    }
    #endif
}
