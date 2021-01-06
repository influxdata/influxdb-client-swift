//
// Created by Jakub Bednář on 06/01/2021.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@testable import InfluxDBSwift
import XCTest

final class DeleteAPITests: XCTestCase {
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

    func testGetDeleteAPI() {
        XCTAssertNotNil(client.getDeleteAPI())
    }
}
