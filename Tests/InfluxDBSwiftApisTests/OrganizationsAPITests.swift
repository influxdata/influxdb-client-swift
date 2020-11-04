//
// Created by Jakub Bednář on 04/11/2020.
//

import InfluxDBSwift
@testable import InfluxDBSwiftApis
import XCTest

class OrganizationsAPITests: APIXCTestCase {
    override func setUp() {
        super.setUp()
        api?.getOrganizationsAPI().getOrgs(limit: 100) { orgs, _ in
            orgs?
                    .orgs?
                    .filter { org in
                        org.name.hasSuffix("_TEST")
                    }.forEach { org in
                        self.api?.getOrganizationsAPI().deleteOrgsID(orgID: org.id!) { _, _ in
                        }
                    }
        }
    }

    func testCreateOrg() {
        let orgName = generateName("org")
        let request = Organization(name: orgName)

        var checker: (Organization) -> Void = { response in
            XCTAssertNotNil(response.id)
            XCTAssertEqual(orgName, response.name)
            XCTAssertNotNil(response.links)
        }

        checkPost(api?.getOrganizationsAPI().postOrgs, request, &checker)
    }
}
