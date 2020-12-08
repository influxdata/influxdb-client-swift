//
// Created by Jakub Bednář on 08/12/2020.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
#if canImport(Combine)
import Combine
#endif

@testable import InfluxDBSwift
import XCTest

final class QueryWriteAPITests: XCTestCase {
    private var client: InfluxDBClient!

    #if canImport(Combine)
    var bag = Set<AnyCancellable>()
    #endif

    override func setUp() {
        client = InfluxDBClient(
                url: Self.dbURL(),
                token: "my-token",
                options: InfluxDBClient.InfluxDBOptions(bucket: "my-bucket", org: "my-org")
        )
    }

    override func tearDown() {
        client.close()
    }

    func testIntegration() {
        var expectation = self.expectation(description: "Success response from API doesn't arrive")

        let measurement = "h2o_\(Date().timeIntervalSince1970)"

        let points = Array(1...5).map {
            InfluxDBClient.Point(measurement)
                    .addTag(key: "host", value: "aws")
                    .addTag(key: "location", value: "west")
                    .addField(key: "value", value: $0)
                    .time(time: Date(2020, 7, $0))
        }

        client.getWriteAPI().writeRecords(records: points) { _, error in
            if let error = error {
                XCTFail("Error occurs: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        expectation = self.expectation(description: "Success response from API doesn't arrive")

        let query = """
                    from(bucket: "my-bucket")
                        |> range(start: 2020)
                        |> filter(fn: (r) => r._measurement == "\(measurement)")
                    """

        client.getQueryAPI().query(query: query) { response, error in
            if let error = error {
                XCTFail("Error occurs: \(error)")
            }

            if let response = response {
                guard let collection = try? Array(response) else {
                    XCTFail("Cannot create an Array.")
                    expectation.fulfill()
                    return
                }
                XCTAssertEqual(1, collection[0].values["_value"] as? Int64)
                XCTAssertEqual("aws", collection[0].values["host"] as? String)
                XCTAssertEqual("west", collection[0].values["location"] as? String)
                XCTAssertEqual(2, collection[1].values["_value"] as? Int64)
                XCTAssertEqual(3, collection[2].values["_value"] as? Int64)
                XCTAssertEqual(4, collection[3].values["_value"] as? Int64)
                XCTAssertEqual(5, collection[4].values["_value"] as? Int64)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
}
