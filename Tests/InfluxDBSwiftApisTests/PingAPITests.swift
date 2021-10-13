//
// Created by Jakub Bednář on 13.10.2021.
//

import InfluxDBSwift
@testable import InfluxDBSwiftApis
import XCTest

final class PingAPITests: APIXCTestCase {
    func testPing() {
        let expectation = self.expectation(description: "Success response from API doesn't arrive")

        api.pingAPI.headPingWithRequestBuilder().execute(api.apiResponseQueue) { result -> Void in
            switch result {
            case let .success(response):
                XCTAssertTrue(response.header["X-Influxdb-Build"] != nil)
                XCTAssertTrue(response.header["X-Influxdb-Version"] != nil)
            case let .failure(error):
                XCTFail(error.description)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
}
