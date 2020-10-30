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
        XCTAssertNotNil(api.getSecretsAPI())
        XCTAssertNotNil(api.getSetupAPI())
        XCTAssertNotNil(api.getTasksAPI())
        XCTAssertNotNil(api.getUsersAPI())
        XCTAssertNotNil(api.getVariablesAPI())
    }
}
