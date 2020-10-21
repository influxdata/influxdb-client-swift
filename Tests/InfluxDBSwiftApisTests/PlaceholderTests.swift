//
// Created by Jakub Bednář on 20/10/2020.
//

@testable import InfluxDBSwiftApis
import XCTest

final class PlaceholderTests: XCTestCase {
    func testCreateInstance() {
        XCTAssertNotNil(Placeholder())
        XCTAssertGreaterThan(Placeholder().dummy(), 0)
    }
}
