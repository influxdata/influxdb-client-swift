//
// Created by Jakub Bednář on 04/11/2020.
//

import InfluxDBSwift
@testable import InfluxDBSwiftApis
import XCTest

class SetupAPITests: APIXCTestCase {
    func testGetSetup() {
        var checker: (IsOnboarding) -> Void = { response in
            XCTAssertEqual(false, response.allowed)
        }

        checkGet(api?.getSetupAPI().getSetup, &checker)
    }
}
