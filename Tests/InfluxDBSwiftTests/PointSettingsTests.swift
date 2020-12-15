//
// Created by Jakub Bednář on 14/12/2020.
//

import Foundation

@testable import InfluxDBSwift
import XCTest

final class PointSettingsTests: XCTestCase {
    func testCreate() {
        let defaultTags = InfluxDBClient.PointSettings()
                .addDefaultTag(key: "id", value: "132-987-655")
                .addDefaultTag(key: "customer", value: "California Miner")
                .addDefaultTag(key: "data_center", value: "${env.DATA_CENTER_LOCATION}")

        XCTAssertEqual(3, defaultTags.tags.count)
    }

    func testEvaluate() {
        setenv("DATA_CENTER_LOCATION", "west", 1)
        let defaultTags = InfluxDBClient.PointSettings()
                .addDefaultTag(key: "id", value: "132-987-655")
                .addDefaultTag(key: "customer", value: "California Miner")
                .addDefaultTag(key: "data_center", value: "${env.DATA_CENTER_LOCATION}")

        XCTAssertEqual([
            "id": "132-987-655",
            "customer": "California Miner",
            "data_center": "west"
        ], defaultTags.evaluate())

        unsetenv("DATA_CENTER_LOCATION")
    }

    func testNotExistEnv() {
        let defaultTags = InfluxDBClient.PointSettings()
                .addDefaultTag(key: "id", value: "132-987-655")
                .addDefaultTag(key: "not_exist", value: "${env.NOT_EXIST_KEY}")

        XCTAssertEqual([
            "id": "132-987-655",
            "not_exist": nil
        ], defaultTags.evaluate())
    }

    func testNilValue() {
        let defaultTags = InfluxDBClient.PointSettings()
                .addDefaultTag(key: "id", value: "132-987-655")
                .addDefaultTag(key: "nil", value: nil)

        XCTAssertEqual([
            "id": "132-987-655",
            "nil": nil
        ], defaultTags.evaluate())
    }
}
