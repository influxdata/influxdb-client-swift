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
    internal static var orgID: String = ""

    override func setUp() {
        client = InfluxDBClient(url: "http://localhost:8086", token: "my-token")
        api = InfluxDB2API(client: client!)
        findMyOrg()
    }

    override func tearDown() {
        if let client = client {
            client.close()
        }
    }

    func generateName(_ prefix: String) -> String {
        "\(prefix)_\(Date().timeIntervalSince1970)_TEST"
    }

    func checkGet<ResponseType: Codable>(_ request: ((String?, Dispatch.DispatchQueue?,
                                                      @escaping (ResponseType?, InfluxDBError?) -> Void) -> Void)?,
                                         _ checker: inout (ResponseType) -> Void) {
        if request == nil {
            XCTFail("Request is not defined!")
        }

        let expectation = self.expectation(description: "Success response from API doesn't arrive")

        if let request = request {
            request(nil, nil, checkResponse(check: checker, expectation: expectation))
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func checkPost<BodyType: Codable, ResponseType: Codable>(_ request: ((BodyType,
                                                                          String?,
                                                                          Dispatch.DispatchQueue?,
                                                                          @escaping (ResponseType?, InfluxDBError?)
                                                                          -> Void) -> Void)?,
                                                             _ body: BodyType,
                                                             _ checker: inout (ResponseType) -> Void) {
        if request == nil {
            XCTFail("Request is not defined!")
            return
        }

        let expectation = self.expectation(description: "Success response from API doesn't arrive")

        if let request = request {
            request(body, nil, nil, checkResponse(check: checker, expectation: expectation))
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    private func checkResponse<ResponseType: Codable>(check: @escaping (ResponseType) -> Void,
                                                      expectation: XCTestExpectation) -> (ResponseType?, InfluxDBError?)
    -> Void { {
            response, error in
            if let error = error {
                XCTFail("Error occurs: \(error)")
                return
            }

            if let response = response {
                //print(dump(response))
                check(response)
                expectation.fulfill()
            }
        }
    }

    private func findMyOrg() {
        guard Self.orgID.isEmpty else {
            return
        }
        let expectation = self.expectation(description: "Cannot find my-org")
        api?.getOrganizationsAPI().getOrgs(limit: 100) { organizations, error in
            if let error = error {
                XCTFail("\(error)")
            }
            if let organizations = organizations {
                Self.orgID = (organizations.orgs?.first { org in
                    org.name == "my-org"
                }?.id)!
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
