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
        XCTAssertNotNil(client.deleteAPI)
    }

    func testBucketOrgParameters() {
        let expectation = XCTestExpectation(description: "Success response from API doesn't arrive")
        expectation.expectedFulfillmentCount = 2

        MockURLProtocol.handler = { request, _ in
            XCTAssertEqual("my-bucket", request.url?.queryParamValue("bucket"))
            XCTAssertEqual("my-org", request.url?.queryParamValue("org"))

            expectation.fulfill()

            let response = HTTPURLResponse(statusCode: 204)
            return (response, Data())
        }

        client.deleteAPI.delete(
                predicate: DeletePredicateRequest(start: Date(), stop: Date()),
                bucket: "my-bucket",
                org: "my-org") { _, error in
            if let error = error {
                XCTFail("Error occurs: \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testBucketIDOrgIDParameters() {
        let expectation = XCTestExpectation(description: "Success response from API doesn't arrive")
        expectation.expectedFulfillmentCount = 2

        MockURLProtocol.handler = { request, _ in
            XCTAssertEqual("org-id", request.url?.queryParamValue("orgID"))
            XCTAssertEqual("bucket-id", request.url?.queryParamValue("bucketID"))

            expectation.fulfill()

            let response = HTTPURLResponse(statusCode: 204)
            return (response, Data())
        }

        client.deleteAPI.delete(
                predicate: DeletePredicateRequest(start: Date(), stop: Date()),
                bucketID: "bucket-id",
                orgID: "org-id") { _, error in
            if let error = error {
                XCTFail("Error occurs: \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testWithoutBucketOrgParameters() {
        let expectation = XCTestExpectation(description: "Success response from API doesn't arrive")
        expectation.expectedFulfillmentCount = 2

        MockURLProtocol.handler = { request, _ in
            XCTAssertNil(request.url?.queryParamValue("bucket"))
            XCTAssertNil(request.url?.queryParamValue("bucketID"))
            XCTAssertNil(request.url?.queryParamValue("org"))
            XCTAssertNil(request.url?.queryParamValue("orgID"))

            expectation.fulfill()

            let response = HTTPURLResponse(statusCode: 204)
            return (response, Data())
        }

        client.deleteAPI.delete(predicate: DeletePredicateRequest(start: Date(), stop: Date())) { _, error in
            if let error = error {
                XCTFail("Error occurs: \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testPredicateRequestSerialization() {
        let expectation = XCTestExpectation(description: "Success response from API doesn't arrive")
        expectation.expectedFulfillmentCount = 2

        MockURLProtocol.handler = { _, bodyData in
            let predicate = try CodableHelper.decode(DeletePredicateRequest.self, from: bodyData!).get()
            XCTAssertEqual(Date(2010, 10, 5), predicate.start)
            XCTAssertEqual(Date(2010, 10, 7), predicate.stop)
            XCTAssertEqual("_measurement=\"sensorData\"", predicate.predicate)

            expectation.fulfill()

            let response = HTTPURLResponse(statusCode: 204)
            return (response, Data())
        }

        let predicate = DeletePredicateRequest(
                start: Date(2010, 10, 5),
                stop: Date(2010, 10, 7),
                predicate: "_measurement=\"sensorData\"")
        client.deleteAPI.delete(predicate: predicate) { result in
            switch result {
            case let .success(response):
                XCTAssertTrue(response == Void())
            case let .failure(error):
                XCTFail("Error occurs: \(error)")
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testErrorResponse() {
        let expectation = XCTestExpectation(description: "Success response from API doesn't arrive")
        expectation.expectedFulfillmentCount = 2

        MockURLProtocol.handler = { request, _ in
            XCTAssertEqual("my-bucket", request.url?.queryParamValue("bucket"))
            XCTAssertEqual("my-org", request.url?.queryParamValue("org"))

            expectation.fulfill()

            let response = HTTPURLResponse(statusCode: 400)
            return (response, Data())
        }

        client.deleteAPI.delete(
                predicate: DeletePredicateRequest(start: Date(), stop: Date()),
                bucket: "my-bucket",
                org: "my-org") { _, error in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    #if swift(>=5.5)
    func testDeleteAsync() async throws {
        let expectation = XCTestExpectation(description: "Success response from API doesn't arrive")
        expectation.expectedFulfillmentCount = 1

        MockURLProtocol.handler = { _, _ in
            expectation.fulfill()

            let response = HTTPURLResponse(statusCode: 204)
            return (response, Data())
        }

        let predicate = DeletePredicateRequest(
                start: Date(2010, 10, 5),
                stop: Date(2010, 10, 7),
                predicate: "_measurement=\"sensorData\"")

        try await client.deleteAPI.delete(predicate: predicate)

        await wait(for: [expectation], timeout: 1)
    }
    #endif
}

extension URL {
    func queryParamValue(_ name: String) -> String? {
        guard let url = URLComponents(string: absoluteString) else {
            return nil
        }
        return url.queryItems?.first {
            $0.name == name
        }?.value
    }
}
