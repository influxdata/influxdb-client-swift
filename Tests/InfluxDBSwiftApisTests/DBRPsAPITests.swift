//
// Created by Jakub Bednář on 04/11/2020.
//

import InfluxDBSwift
@testable import InfluxDBSwiftApis
import XCTest

class DBRPsAPITests: APIXCTestCase {
    override func setUp() {
        super.setUp()
        api?.getDBRPsAPI().getDBRPs(orgID: Self.orgID) { dbrps, _ in
            dbrps?
                    .notificationEndpoints?
                    .forEach { dbrp in
                        self.api?.getDBRPsAPI().deleteDBRPID(orgID: Self.orgID, dbrpID: dbrp.id!) { _, _ in
                        }
                    }
        }
    }

    func testCreateDBRPS() {
        let request = DBRP(
                orgID: Self.orgID,
                bucketID: "70fe9e54232f9908",
                database: "my-database",
                retentionPolicy: "my-retention")

        var checker: (DBRP) -> Void = { response in
            XCTAssertNotNil(response.id)
            XCTAssertEqual(Self.orgID, response.orgID)
            XCTAssertEqual("my-database", response.database)
            XCTAssertEqual("my-database", response.retentionPolicy)
            XCTAssertNotNil(response.links)
        }

        checkPost(api?.getDBRPsAPI().postDBRP, request, &checker)
    }
}
