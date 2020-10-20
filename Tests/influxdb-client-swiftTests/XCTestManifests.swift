import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    [
        testCase(InfluxDBClientTests.allTests),
    ]
}
#endif
