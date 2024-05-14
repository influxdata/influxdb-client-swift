//
// Created by Jakub Bednář on 20/10/2020.
//

import InfluxDBSwift
@testable import InfluxDBSwiftApis
import XCTest

final class InfluxDB2APITests: XCTestCase {
    private var client: InfluxDBClient?

    override func setUp() {
        client = InfluxDBClient(url: Self.apiURL(), token: "my-token")
    }

    override func tearDown() {
        if let client = client {
            client.close()
        }
    }

    override func tearDownWithError() throws {
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
        XCTAssertNotNil(api.authorizationsAPI)
        XCTAssertNotNil(api.bucketsAPI)
        XCTAssertNotNil(api.dbrpsAPI)
        XCTAssertNotNil(api.healthAPI)
        XCTAssertNotNil(api.labelsAPI)
        XCTAssertNotNil(api.organizationsAPI)
        XCTAssertNotNil(api.readyAPI)
        XCTAssertNotNil(api.scraperTargetsAPI)
        XCTAssertNotNil(api.secretsAPI)
        XCTAssertNotNil(api.setupAPI)
        XCTAssertNotNil(api.sourcesAPI)
        XCTAssertNotNil(api.tasksAPI)
        XCTAssertNotNil(api.usersAPI)
        XCTAssertNotNil(api.variablesAPI)
    }

    func testURLSession() {
        let api = InfluxDB2API(client: client!)
        XCTAssertEqual(client?.session, api.urlSession)
    }
}

class APIXCTestCase: XCTestCase {
    internal var client: InfluxDBClient!
    internal var api: InfluxDB2API!
    internal static var orgID: String = ""
    internal static var bucketID: String = ""

    override func setUp() {
        client = InfluxDBClient(url: Self.apiURL(), token: "my-token")
        api = InfluxDB2API(client: client!)
        findMyOrg()
        findMyBucket()
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
                                                      @escaping (ResponseType?, InfluxDBClient.InfluxDBError?) -> Void)
                                                     -> Void)?,
                                         _ checker: inout (ResponseType) -> Void) {
        if request == nil {
            XCTFail("Request is not defined!")
        }

        let expectation = XCTestExpectation(description: "Success response from API doesn't arrive")

        if let request = request {
            request(nil, nil, checkResponse(check: checker, expectation: expectation))
        }

        wait(for: [expectation], timeout: 5)
    }

    func checkPost<BodyType: Codable, ResponseType: Codable>(_ request: ((BodyType,
                                                                          Dispatch.DispatchQueue?,
                                                                          @escaping (ResponseType?,
                                                                                     InfluxDBClient.InfluxDBError?)
                                                                          -> Void) -> Void)?,
                                                             _ body: BodyType,
                                                             _ checker: inout (ResponseType) -> Void) {
        if request == nil {
            XCTFail("Request is not defined!")
            return
        }

        let expectation = XCTestExpectation(description: "Success response from API doesn't arrive")

        if let request = request {
            request(body, nil, checkResponse(check: checker, expectation: expectation))
        }

        wait(for: [expectation], timeout: 5)
    }

    func checkPost<BodyType: Codable, ResponseType: Codable>(_ request: ((BodyType,
                                                                          String?,
                                                                          Dispatch.DispatchQueue?,
                                                                          @escaping (ResponseType?,
                                                                                     InfluxDBClient.InfluxDBError?)
                                                                          -> Void) -> Void)?,
                                                             _ body: BodyType,
                                                             _ checker: inout (ResponseType) -> Void) {
        if request == nil {
            XCTFail("Request is not defined!")
            return
        }

        let expectation = XCTestExpectation(description: "Success response from API doesn't arrive")

        if let request = request {
            request(body, nil, nil, checkResponse(check: checker, expectation: expectation))
        }

        wait(for: [expectation], timeout: 5)
    }

    private func checkResponse<ResponseType: Codable>(check: @escaping (ResponseType) -> Void,
                                                      expectation: XCTestExpectation) -> (ResponseType?,
                                                                                          InfluxDBClient.InfluxDBError?)
    -> Void {
        { response, error in
            if let error = error {
                XCTFail("Error occurs: \(error)")
            }

            if let response = response {
                // print(dump(response))
                check(response)
            }

            expectation.fulfill()
        }
    }

    private func findMyOrg() {
        guard Self.orgID.isEmpty else {
            return
        }
        let expectation = XCTestExpectation(description: "Cannot find my-org")
        api.organizationsAPI.getOrgs(limit: 100) { organizations, error in
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
        wait(for: [expectation], timeout: 5)
    }

    private func findMyBucket() {
        guard Self.bucketID.isEmpty else {
            return
        }
        let expectation = XCTestExpectation(description: "Cannot find my-bucket")
        api.bucketsAPI.getBuckets(limit: 100) { response, error in
            if let error = error {
                XCTFail("\(error)")
            }
            if let response = response {
                Self.bucketID = (response.buckets?.first { bucket in
                    bucket.name == "my-bucket"
                }?.id)!
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5)
    }
}

extension XCTestCase {
    internal static func apiURL() -> String {
        if let url = ProcessInfo.processInfo.environment["INFLUXDB_URL"] {
            return url
        }
        return "http://localhost:8086"
    }
}
