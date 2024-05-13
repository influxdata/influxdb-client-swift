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

final class IntegrationTests: XCTestCase {
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

    func testQueryWriteIntegration() {
        var expectation = XCTestExpectation(description: "Success response from API doesn't arrive")

        let measurement = "h2o_\(Date().timeIntervalSince1970)"

        let points = Array(1...5).map {
            InfluxDBClient.Point(measurement)
                    .addTag(key: "host", value: "aws")
                    .addTag(key: "location", value: "west")
                    .addField(key: "value", value: .int($0))
                    .time(time: .date(Date(2020, 7, $0)))
        }

        client.makeWriteAPI().write(points: points) { _, error in
            if let error = error {
                XCTFail("Error occurs: \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
        expectation = XCTestExpectation(description: "Success response from API doesn't arrive")

        let query = """
                    from(bucket: "my-bucket")
                        |> range(start: 2020)
                        |> filter(fn: (r) => r._measurement == "\(measurement)")
                    """

        client.queryAPI.query(query: query) { response, error in
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

        wait(for: [expectation], timeout: 5)
    }

    func testDelete() {
        var expectation = XCTestExpectation(description: "Success response from Write API doesn't arrive")

        let measurement = "h2o_\(Date().timeIntervalSince1970)"

        let point1 = InfluxDBClient.Point(measurement)
                .addTag(key: "host", value: "aws")
                .addTag(key: "location", value: "west")
                .addField(key: "value", value: .int(1))
                .time(time: .date(Date(2020, 7, 1)))

        let point2 = InfluxDBClient.Point(measurement)
                .addTag(key: "host", value: "azure")
                .addTag(key: "location", value: "west")
                .addField(key: "value", value: .int(2))
                .time(time: .date(Date(2020, 7, 2)))

        let point3 = InfluxDBClient.Point(measurement)
                .addTag(key: "host", value: "gc")
                .addTag(key: "location", value: "west")
                .addField(key: "value", value: .int(3))
                .time(time: .date(Date(2020, 7, 3)))

        client.makeWriteAPI().write(points: [point1, point2, point3]) { _, error in
            if let error = error {
                XCTFail("Error occurs: \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
        expectation = XCTestExpectation(description: "Success response from Query API doesn't arrive")

        let query = """
                    from(bucket: "my-bucket")
                        |> range(start: 2020)
                        |> filter(fn: (r) => r._measurement == "\(measurement)")
                    """

        client.queryAPI.query(query: query) { response, error in
            if let error = error {
                XCTFail("Error occurs: \(error)")
            }

            if let response = response {
                guard let collection = try? Array(response) else {
                    XCTFail("Cannot create an Array.")
                    expectation.fulfill()
                    return
                }
                XCTAssertEqual(3, collection.count)
                XCTAssertEqual("aws", collection[0].values["host"] as? String)
                XCTAssertEqual("azure", collection[1].values["host"] as? String)
                XCTAssertEqual("gc", collection[2].values["host"] as? String)
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)

        expectation = XCTestExpectation(description: "Success response from Delete API doesn't arrive")

        let predicate = DeletePredicateRequest(
                start: Date(2019, 10, 5),
                stop: Date(2021, 10, 7),
                predicate: "_measurement=\"\(measurement)\" AND host=\"azure\"")

        client.deleteAPI.delete(predicate: predicate, bucket: "my-bucket", org: "my-org") { _, error in
            if let error = error {
                XCTFail("Error occurs: \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)

        expectation = XCTestExpectation(description: "Success response from Query API doesn't arrive")

        client.queryAPI.query(query: query) { response, error in
            if let error = error {
                XCTFail("Error occurs: \(error)")
            }

            if let response = response {
                guard let collection = try? Array(response) else {
                    XCTFail("Cannot create an Array.")
                    expectation.fulfill()
                    return
                }
                XCTAssertEqual(2, collection.count)
                XCTAssertEqual("aws", collection[0].values["host"] as? String)
                XCTAssertEqual("gc", collection[1].values["host"] as? String)
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }
}
