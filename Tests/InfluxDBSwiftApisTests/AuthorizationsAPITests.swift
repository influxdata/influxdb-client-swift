//
// Created by Jakub Bednář on 04/11/2020.
//

import InfluxDBSwift
@testable import InfluxDBSwiftApis
import XCTest

class AuthorizationsAPITests: APIXCTestCase {
    override func setUp() {
        super.setUp()
        api.authorizationsAPI.getAuthorizations { authorizations, _ in
            authorizations?
                    .authorizations?
                    .filter { authorization in
                        if let description = authorization.description {
                            return description.hasSuffix("_TEST")
                        }
                        return false
                    }.forEach { authorization in
                        self.api.authorizationsAPI.deleteAuthorizationsID(authID: authorization.id!) { _, _ in
                        }
                    }
        }
    }

    func testCreateAuthorization() {
        let authorizationDesc = generateName("authorization")

        let request = Authorization(
                description: authorizationDesc,
                orgID: Self.orgID,
                permissions: [
                    Permission(
                            action: Permission.Action.read,
                            resource: Resource(
                                    type: Resource.ModelType.users,
                                    orgID: Self.orgID
                            )
                    )
                ])

        var checker: (Authorization) -> Void = { response in
            XCTAssertNotNil(response.id)
            XCTAssertEqual(authorizationDesc, response.description)
            XCTAssertEqual(Self.orgID, response.orgID)
            XCTAssertEqual(Permission.Action.read, response.permissions[0].action)
            XCTAssertEqual(Self.orgID, response.permissions[0].resource.orgID)
            XCTAssertEqual(Resource.ModelType.users, response.permissions[0].resource.type)
            XCTAssertNotNil(response.links)
        }

        checkPost(api.authorizationsAPI.postAuthorizations, request, &checker)
    }
}
