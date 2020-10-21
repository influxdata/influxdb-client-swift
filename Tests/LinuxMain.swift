import XCTest

import InfluxDBSwiftApisTests
import InfluxDBSwiftTests

var tests = [XCTestCaseEntry]()
tests += InfluxDBSwiftApisTests.__allTests()
tests += InfluxDBSwiftTests.__allTests()

XCTMain(tests)
