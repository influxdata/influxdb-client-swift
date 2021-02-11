//
// Created by Jakub Bednář on 04/11/2020.
//

import InfluxDBSwift
@testable import InfluxDBSwiftApis
import XCTest

class DBRPsAPITests: APIXCTestCase {
    override func setUp() {
        super.setUp()
        api.getDBRPsAPI().getDBRPs(orgID: Self.orgID) { dbrps, _ in
            dbrps?
                    .content?
                    .forEach { dbrp in
                        self.api.getDBRPsAPI().deleteDBRPID(orgID: Self.orgID, dbrpID: dbrp.id!) { _, _ in
                        }
                    }
        }
    }

    func testCreateDBRPS() {
        let policyName = generateName("retention_policy")
        let request = DBRP(
                org: "my-org",
                bucketID: Self.bucketID,
                database: "my-db",
                retentionPolicy: policyName)

        var checker: (DBRP) -> Void = { response in
            XCTAssertNotNil(response.id)
            XCTAssertEqual(Self.orgID, response.orgID)
            XCTAssertEqual(Self.bucketID, response.bucketID)
            XCTAssertEqual("my-db", response.database)
            XCTAssertEqual(policyName, response.retentionPolicy)
        }

        checkPost(api.getDBRPsAPI().postDBRP, request, &checker)
    }
}
