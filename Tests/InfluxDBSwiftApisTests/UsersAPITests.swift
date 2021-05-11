//
// Created by Jakub Bednář on 04/11/2020.
//

import InfluxDBSwift
@testable import InfluxDBSwiftApis
import XCTest

class UsersAPITests: APIXCTestCase {
    override func setUp() {
        super.setUp()
        api.usersAPI.getUsers { users, _ in
            users?
                    .users?
                    .filter { user in
                        user.name.hasSuffix("_TEST")
                    }.forEach { user in
                        self.api.usersAPI.deleteUsersID(userID: user.id!) { _, _ in
                        }
                    }
        }
    }

    func testCreateUser() {
        let userName = generateName("user")
        let request = User(name: userName, status: User.Status.active)

        var checker: (UserResponse) -> Void = { response in
            XCTAssertNotNil(response.id)
            XCTAssertEqual(userName, response.name)
            XCTAssertEqual(UserResponse.Status.active, response.status)
            XCTAssertNotNil(response.links)
        }

        checkPost(api.usersAPI.postUsers, request, &checker)
    }
}
