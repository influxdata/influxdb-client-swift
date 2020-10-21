//
// Created by Jakub Bednář on 20/10/2020.
//

@testable import InfluxDBSwift
import XCTest

final class InfluxDBClientTests: XCTestCase {
    func testCreateInstance() {
        XCTAssertNotNil(InfluxDBClient())
    }
}
