//
// Created by Jakub Bednář on 04/11/2020.
//

import InfluxDBSwift
@testable import InfluxDBSwiftApis
import XCTest

class SecretsAPITests: APIXCTestCase {
    override func setUp() {
        super.setUp()
        api.secretsAPI.getOrgsIDSecrets(orgID: Self.orgID) { response, _ in
            let secrets = response?
                    .secrets?
                    .filter { secret in
                        secret.hasSuffix("_TEST")
                    }

            self.api.secretsAPI
                    .postOrgsIDSecrets(orgID: Self.orgID, secretKeys: SecretKeys(secrets: secrets)) { _, _ in
                    }
        }
    }

    func testCreateSecret() {
        let request = [generateName("secret"): generateName("secret")]

        let expectation = XCTestExpectation(description: "Success response from API doesn't arrive")

        self.api.secretsAPI.patchOrgsIDSecrets(orgID: Self.orgID, requestBody: request) { _, error in
            if let error = error {
                XCTFail("Error occurs: \(error)")
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }
}
