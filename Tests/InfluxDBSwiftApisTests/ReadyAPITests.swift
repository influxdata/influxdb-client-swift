//
// Created by Jakub Bednář on 02/11/2020.
//

import InfluxDBSwift
@testable import InfluxDBSwiftApis
import XCTest

final class ReadyAPITests: APIXCTestCase {
    func testReady() {
        var checker: (Ready) -> Void = { response in
            XCTAssertEqual(Ready.Status.ready, response.status)
            XCTAssertNotNil(response.up)
            XCTAssertNotNil(response.started)
        }

        checkGet(api?.getReadyAPI().getReady, &checker)
    }
}
