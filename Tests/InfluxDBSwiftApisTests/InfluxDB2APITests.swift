//
// Created by Jakub Bednář on 20/10/2020.
//

import InfluxDBSwift
@testable import InfluxDBSwiftApis
import XCTest

final class InfluxDB2APITests: XCTestCase {
    private var client: InfluxDBClient?

    override func setUp() {
        client = InfluxDBClient(url: "http://localhost:8086", token: "my-token")
    }

    override func tearDown() {
        if let client = client {
            client.close()
        }
    }

    func testCreateInstance() {
        let api = InfluxDB2API(client: client!)
        XCTAssertNotNil(api)
    }

    func testCreateApis() {
        let api = InfluxDB2API(client: client!)
        XCTAssertNotNil(api.getAuthorizationsAPI())
        XCTAssertNotNil(api.getBucketsAPI())
        XCTAssertNotNil(api.getDBRPsAPI())
        XCTAssertNotNil(api.getHealthAPI())
        XCTAssertNotNil(api.getLabelsAPI())
        XCTAssertNotNil(api.getOrganizationsAPI())
        XCTAssertNotNil(api.getReadyAPI())
        XCTAssertNotNil(api.getScraperTargetsAPI())
        XCTAssertNotNil(api.getSecretsAPI())
        XCTAssertNotNil(api.getSetupAPI())
        XCTAssertNotNil(api.getSourcesAPI())
        XCTAssertNotNil(api.getTasksAPI())
        XCTAssertNotNil(api.getUsersAPI())
        XCTAssertNotNil(api.getVariablesAPI())
    }

    func testURLSession() {
        let api = InfluxDB2API(client: client!)
        XCTAssertEqual(client?.session, api.getURLSession())
    }
}

class APIXCTestCase: XCTestCase {
    internal var client: InfluxDBClient?
    internal var api: InfluxDB2API?

    override func setUp() {
        client = InfluxDBClient(url: "http://localhost:8086", token: "my-token")
        api = InfluxDB2API(client: client!)
    }

    override func tearDown() {
        if let client = client {
            client.close()
        }
    }

    func check<RF: Codable>(_ request: ((String?, Dispatch.DispatchQueue?, @escaping (RF?, Error?) -> Void) -> Void)?,
                            _ checker: inout (RF) -> Void) {
        if request == nil {
            XCTFail("Request is not defined!")
            return
        }

        let expectation = self.expectation(description: "Download apple.com home page")
        let check = checker

        if let request = request {
            request(nil, nil) { response, error in
                if let error = error {
                    XCTFail("Error occurs: \(error)")
                    return
                }

                if let response = response {
                    print("Response: \(response)")
                    check(response)
                    expectation.fulfill()
                }
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
}
