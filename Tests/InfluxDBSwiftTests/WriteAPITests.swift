//
// Created by Jakub Bednář on 10/11/2020.
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

final class WriteAPITests: XCTestCase {
    private var client: InfluxDBClient!

    #if canImport(Combine)
    var bag = Set<AnyCancellable>()
    #endif

    override func setUp() {
        client = InfluxDBClient(
                url: Self.dbURL(),
                token: "my-token",
                protocolClasses: [MockURLProtocol.self])
    }

    override func tearDown() {
        client.close()
    }

    func testGetWriteAPI() {
        XCTAssertNotNil(client.getWriteAPI())
    }

    func testWriteRecord() {
        let expectation = self.expectation(description: "Success response from API doesn't arrive")
        expectation.expectedFulfillmentCount = 2

        MockURLProtocol.handler = simpleWriteHandler(expectation: expectation)

        client.getWriteAPI().writeRecord(record: "mem,tag=a value=1") { response, error in
            if let error = error {
                XCTFail("Error occurs: \(error)")
            }

            if let response = response {
                XCTAssertTrue(response == Void())
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testWriteRecordGzip() {
        client.close()

        client = InfluxDBClient(
                url: Self.dbURL(),
                token: "my-token",
                options: InfluxDBClient.InfluxDBOptions(enableGzip: true),
                protocolClasses: [MockURLProtocol.self])

        let expectation = self.expectation(description: "Success response from API doesn't arrive")
        expectation.expectedFulfillmentCount = 2

        MockURLProtocol.handler = { request, bodyData in
            XCTAssertEqual("37", request.allHTTPHeaderFields!["Content-Length"])
            XCTAssertEqual("gzip", request.allHTTPHeaderFields!["Content-Encoding"])
            XCTAssertNotNil(bodyData)

            XCTAssertEqual("mem,tag=a value=1", try String(decoding: bodyData!.gunzipped(), as: UTF8.self))

            expectation.fulfill()

            let response = HTTPURLResponse(statusCode: 204)
            return (response, Data())
        }

        client.getWriteAPI().writeRecord(record: "mem,tag=a value=1") { _, _ in
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testWriteRecords() {
        let expectation = self.expectation(description: "Success response from API doesn't arrive")
        expectation.expectedFulfillmentCount = 2

        MockURLProtocol.handler = { request, bodyData in
            XCTAssertEqual(
                    "mem,tag=a value=1\\nmem,tag=a value=2\\nmem,tag=a value=3\\nmem,tag=a value=4",
                    String(decoding: bodyData!, as: UTF8.self))

            expectation.fulfill()

            let response = HTTPURLResponse(statusCode: 204)
            return (response, Data())
        }

        let records = ["mem,tag=a value=1", "mem,tag=a value=2", " ", "mem,tag=a value=3", "", "mem,tag=a value=4"]
        client.getWriteAPI().writeRecords(records: records) { _, _ in
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testWriteRecordResult() {
        let expectation = self.expectation(description: "Success response from API doesn't arrive")
        expectation.expectedFulfillmentCount = 2

        MockURLProtocol.handler = simpleWriteHandler(expectation: expectation)

        client.getWriteAPI().writeRecord(record: "mem,tag=a value=1") { result in
            switch result {
            case let .success(response):
                XCTAssertTrue(response == Void())
            case let .failure(error):
                XCTFail("Error occurs: \(error)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testWriteRecordCombine() {
        #if canImport(Combine)
        let expectation = self.expectation(description: "Success response from API doesn't arrive")
        expectation.expectedFulfillmentCount = 2

        MockURLProtocol.handler = simpleWriteHandler(expectation: expectation)

       client.getWriteAPI()
                .writeRecord(record: "mem,tag=a value=1")
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTFail("Error occurs: \(error)")
                    }

                    expectation.fulfill()
                }, receiveValue: { response in
                    XCTAssertTrue(response == Void())
                })
               .store(in: &bag)

        waitForExpectations(timeout: 1, handler: nil)
        #endif
    }

    private func simpleWriteHandler(expectation: XCTestExpectation) -> (URLRequest, Data?)
    -> (HTTPURLResponse, Data) { { request, bodyData in
            XCTAssertEqual(
                    "influxdb-client-swift/\(InfluxDBClient.self.version)",
                    request.allHTTPHeaderFields!["User-Agent"])
            XCTAssertEqual("Token my-token", request.allHTTPHeaderFields!["Authorization"])
            XCTAssertEqual("text/plain; charset=utf-8", request.allHTTPHeaderFields!["Content-Type"])
            XCTAssertEqual("17", request.allHTTPHeaderFields!["Content-Length"])
            XCTAssertEqual("identity", request.allHTTPHeaderFields!["Content-Encoding"])
            XCTAssertEqual("identity", request.allHTTPHeaderFields!["Accept-Encoding"])
            XCTAssertEqual("\(Self.dbURL())/api/v2/write", request.url?.description)

            XCTAssertEqual("mem,tag=a value=1", String(decoding: bodyData!, as: UTF8.self))

            expectation.fulfill()

            let response = HTTPURLResponse(statusCode: 204)
            return (response, Data())
        }
    }
}
