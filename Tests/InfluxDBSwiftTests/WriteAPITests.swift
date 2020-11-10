//
// Created by Jakub Bednář on 10/11/2020.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@testable import InfluxDBSwift
import XCTest

final class WriteAPITests: XCTestCase {
    private var client: InfluxDBClient?

    override func setUp() {
        client = InfluxDBClient(url: "http://localhost:8086", token: "my-token")
    }

    override func tearDown() {
        if let client = client {
            client.close()
        }
    }

    func testGetWriteAPI() {
        XCTAssertNotNil(client?.getWriteAPI())
    }

    func testWriteRecord() {
        let expectation = self.expectation(description: "Success response from API doesn't arrive")

        client?.getWriteAPI().writeRecord(record: "mem,tag=a value=1") { response, error in
            if let error = error {
                XCTFail("Error occurs: \(error)")
            }

            if let response = response {
                XCTAssertNil(response)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testWriteRecordResult() {
        let expectation = self.expectation(description: "Success response from API doesn't arrive")

        client?.getWriteAPI().writeRecord(record: "mem,tag=a value=1") { result in
            switch result {
            case let .success(response):
                XCTAssertNil(response)
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

        _ = client?.getWriteAPI()
                .writeRecord(record: "mem,tag=a value=1")
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTFail("Error occurs: \(error)")
                    }

                    expectation.fulfill()
                }, receiveValue: { response in
                    XCTAssertNil(response)
                })

        waitForExpectations(timeout: 1, handler: nil)
        #endif
    }
}
