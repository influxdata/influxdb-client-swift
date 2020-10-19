import XCTest

import influxdb_client_swiftTests

var tests = [XCTestCaseEntry]()
tests += influxdb_client_swiftTests.allTests()
XCTMain(tests)