//
// Created by Jakub Bednář on 01.04.2022.
//

import Foundation

@testable import InfluxDBSwift
import XCTest

final class InvocableScriptsAPITests: XCTestCase {
    private var client: InfluxDBClient!

    override func setUp() {
        client = InfluxDBClient(
                url: Self.dbURL(),
                token: "my-token",
                options: InfluxDBClient.InfluxDBOptions(bucket: "my-bucket", org: "my-org"),
                protocolClasses: [MockURLProtocol.self])
    }

    override func tearDown() {
        client.close()
    }

    func testGetInvocableScriptsApi() {
        XCTAssertNotNil(client.invocableScriptsApi)
    }
}
