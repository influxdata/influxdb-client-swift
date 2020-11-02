//
// Created by Jakub Bednář on 02/11/2020.
//

import InfluxDBSwift
@testable import InfluxDBSwiftApis
import XCTest

final class HealthAPITests: APIXCTestCase {
    func testHealth() {
        var checker: (HealthCheck) -> Void = { response in
            XCTAssertEqual(HealthCheck.Status.pass, response.status)
        }

        check(api?.getHealthAPI().getHealth, &checker)
    }
}
