import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(influxdb_client_swiftTests.allTests),
    ]
}
#endif
