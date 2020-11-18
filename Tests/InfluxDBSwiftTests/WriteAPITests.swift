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
                options: InfluxDBClient.InfluxDBOptions(bucket: "my-bucket", org: "my-org"),
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

        client.getWriteAPI().writeRecord(record: "mem,tag=a value=1i") { response, error in
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

    func testWritePoint() {
        let expectation = self.expectation(description: "Success response from API doesn't arrive")
        expectation.expectedFulfillmentCount = 2

        MockURLProtocol.handler = simpleWriteHandler(expectation: expectation)

        let record = InfluxDBClient.Point("mem").addTag(key: "tag", value: "a").addField(key: "value", value: 1)
        client.getWriteAPI().writeRecord(record: record) { response, error in
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

    func testWritePointsDifferentPrecision() {
        let expectation = self.expectation(description: "Success response from API doesn't arrive")
        expectation.expectedFulfillmentCount = 4

        var requests: [URLRequest] = []
        var bodies: [String] = []
        MockURLProtocol.handler = { request, bodyData in
            requests.append(request)
            bodies.append(String(decoding: bodyData!, as: UTF8.self))

            expectation.fulfill()

            let response = HTTPURLResponse(statusCode: 204)
            return (response, Data())
        }

        let record1 = InfluxDBClient.Point("mem")
                .addTag(key: "tag", value: "a")
                .addField(key: "value", value: 1)
                .time(time: 1, precision: InfluxDBClient.WritePrecision.s)
        let record2 = InfluxDBClient.Point("mem")
                .addTag(key: "tag", value: "b")
                .addField(key: "value", value: 2)
                .time(time: 2, precision: InfluxDBClient.WritePrecision.ns)

        client.getWriteAPI().writeRecords(records: [record1, [record2]]) { _, _ in
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)

        XCTAssertEqual(2, requests.count)
        XCTAssertEqual(
                "\(Self.dbURL())/api/v2/write?bucket=my-bucket&org=my-org&precision=s",
                requests[0].url?.description)
        XCTAssertEqual(
                "\(Self.dbURL())/api/v2/write?bucket=my-bucket&org=my-org&precision=ns",
                requests[1].url?.description)
        XCTAssertEqual(2, bodies.count)
        XCTAssertEqual("mem,tag=a value=1i 1", bodies[0])
        XCTAssertEqual("mem,tag=b value=2i 2", bodies[1])
    }

    func testWriteArrayOfArray() {
        let expectation = self.expectation(description: "Success response from API doesn't arrive")
        expectation.expectedFulfillmentCount = 2

        MockURLProtocol.handler = { request, bodyData in
            XCTAssertEqual(
                    "mem,tag=a value=1i\\nmem,tag=b value=2i",
                    String(decoding: bodyData!, as: UTF8.self))

            expectation.fulfill()

            let response = HTTPURLResponse(statusCode: 204)
            return (response, Data())
        }

        let record1 = InfluxDBClient.Point("mem").addTag(key: "tag", value: "a").addField(key: "value", value: 1)
        let record2 = InfluxDBClient.Point("mem").addTag(key: "tag", value: "b").addField(key: "value", value: 2)
        client.getWriteAPI().writeRecords(records: [record1, [record2]]) { response, error in
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
                options: InfluxDBClient.InfluxDBOptions(bucket: "my-bucket", org: "my-org", enableGzip: true),
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
        client.getWriteAPI().writeRecords(records: records) { _, error in
            if let error = error {
                XCTFail("Error occurs: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testWriteRecordTypes() {
        let expectation = self.expectation(description: "Success response from API doesn't arrive")
        expectation.expectedFulfillmentCount = 2

        let required = "mem,tag=a value=1\\nmem,tag=a value=2i\\nmem,tag=a value=3i"
                + "\\nmem value=4i\\nmem,tag=a value=5i 5\\nmem value=6i 6"

        MockURLProtocol.handler = { request, bodyData in
            XCTAssertEqual(
                    required,
                    String(decoding: bodyData!, as: UTF8.self))

            expectation.fulfill()

            let response = HTTPURLResponse(statusCode: 204)
            return (response, Data())
        }

        let records: [Any] = [
            "mem,tag=a value=1",
            InfluxDBClient.Point("mem").addTag(key: "tag", value: "a").addField(key: "value", value: 2),
            (measurement: "mem", tags: ["tag": "a"], fields: ["value": 3]),
            (measurement: "mem", fields: ["value": 4]),
            (measurement: "mem", tags: ["tag": "a"], fields: ["value": 5], time: 5),
            (measurement: "mem", fields: ["value": 6], time: 6)
        ]

        client.getWriteAPI().writeRecords(records: records) { _, error in
            if let error = error {
                XCTFail("Error occurs: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testWriteRecordResult() {
        let expectation = self.expectation(description: "Success response from API doesn't arrive")
        expectation.expectedFulfillmentCount = 2

        MockURLProtocol.handler = simpleWriteHandler(expectation: expectation)

        client.getWriteAPI().writeRecord(record: "mem,tag=a value=1i") { result in
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
                .writeRecord(record: "mem,tag=a value=1i")
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
            XCTAssertEqual("18", request.allHTTPHeaderFields!["Content-Length"])
            XCTAssertEqual("identity", request.allHTTPHeaderFields!["Content-Encoding"])
            XCTAssertEqual("identity", request.allHTTPHeaderFields!["Accept-Encoding"])
            XCTAssertEqual(
                    "\(Self.dbURL())/api/v2/write?bucket=my-bucket&org=my-org&precision=ns",
                    request.url?.description)
            XCTAssertEqual("bucket=my-bucket&org=my-org&precision=ns", request.url?.query)

            XCTAssertEqual("mem,tag=a value=1i", String(decoding: bodyData!, as: UTF8.self))

            expectation.fulfill()

            let response = HTTPURLResponse(statusCode: 204)
            return (response, Data())
        }
    }
}
