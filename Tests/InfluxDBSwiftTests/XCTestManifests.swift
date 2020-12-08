#if !canImport(ObjectiveC)
import XCTest

extension FluxCSVParserTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__FluxCSVParserTests = [
        ("testError", testError),
        ("testErrorWithoutReference", testErrorWithoutReference),
        ("testGroupKey", testGroupKey),
        ("testMappingBase64Binary", testMappingBase64Binary),
        ("testMappingBoolean", testMappingBoolean),
        ("testMappingDouble", testMappingDouble),
        ("testMappingDuration", testMappingDuration),
        ("testMappingRFC3339", testMappingRFC3339),
        ("testMappingRFC3339Nano", testMappingRFC3339Nano),
        ("testMappingUnsignedLong", testMappingUnsignedLong),
        ("testMultipleQueries", testMultipleQueries),
        ("testParseExportFromUserInterface", testParseExportFromUserInterface),
        ("testResponseWithError", testResponseWithError),
        ("testResponseWithMultipleValues", testResponseWithMultipleValues),
        ("testShortcut", testShortcut),
        ("testTableIndexNotStartAtZero", testTableIndexNotStartAtZero),
        ("testUnknownTypeAsString", testUnknownTypeAsString),
        ("testWithoutTableDefinition", testWithoutTableDefinition),
    ]
}

extension InfluxDBClientTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__InfluxDBClientTests = [
        ("testBaseURL", testBaseURL),
        ("testCreateInstance", testCreateInstance),
        ("testSessionHeaders", testSessionHeaders),
        ("testSessionHeadersV1", testSessionHeadersV1),
        ("testTimeoutConfigured", testTimeoutConfigured),
        ("testTimeoutDefault", testTimeoutDefault),
    ]
}

extension InfluxDBErrorTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__InfluxDBErrorTests = [
        ("testDescription", testDescription),
    ]
}

extension PointTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__PointTests = [
        ("testDateTimeFormatting", testDateTimeFormatting),
        ("testDescription", testDescription),
        ("testEqualSignEscaping", testEqualSignEscaping),
        ("testFieldEscape", testFieldEscape),
        ("testFieldNullValue", testFieldNullValue),
        ("testFieldTypes", testFieldTypes),
        ("testFromTuple", testFromTuple),
        ("testInfinityValues", testInfinityValues),
        ("testMeasurementEscape", testMeasurementEscape),
        ("testOnlyInfinityValues", testOnlyInfinityValues),
        ("testOverrideTagField", testOverrideTagField),
        ("testPointProtocol", testPointProtocol),
        ("testPointsFromDifferentTimezones", testPointsFromDifferentTimezones),
        ("testTagEmptyKey", testTagEmptyKey),
        ("testTagEmptyValue", testTagEmptyValue),
        ("testTagEscapingKeyAndValue", testTagEscapingKeyAndValue),
        ("testTime", testTime),
        ("testTimePrecisionDefault", testTimePrecisionDefault),
        ("testTimestamp", testTimestamp),
    ]
}

extension QueryAPITests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__QueryAPITests = [
        ("testGetQueryAPI", testGetQueryAPI),
        ("testQuery", testQuery),
        ("testQueryRaw", testQueryRaw),
    ]
}

extension QueryWriteAPITests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__QueryWriteAPITests = [
        ("testIntegration", testIntegration),
    ]
}

extension WriteAPITests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__WriteAPITests = [
        ("testBucketAndOrgAreRequired", testBucketAndOrgAreRequired),
        ("testGetWriteAPI", testGetWriteAPI),
        ("testUnsuccessfulResponse", testUnsuccessfulResponse),
        ("testWriteArrayOfArray", testWriteArrayOfArray),
        ("testWritePoint", testWritePoint),
        ("testWritePointsDifferentPrecision", testWritePointsDifferentPrecision),
        ("testWriteRecord", testWriteRecord),
        ("testWriteRecordCombine", testWriteRecordCombine),
        ("testWriteRecordGzip", testWriteRecordGzip),
        ("testWriteRecordResult", testWriteRecordResult),
        ("testWriteRecords", testWriteRecords),
        ("testWriteRecordTypes", testWriteRecordTypes),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(FluxCSVParserTests.__allTests__FluxCSVParserTests),
        testCase(InfluxDBClientTests.__allTests__InfluxDBClientTests),
        testCase(InfluxDBErrorTests.__allTests__InfluxDBErrorTests),
        testCase(PointTests.__allTests__PointTests),
        testCase(QueryAPITests.__allTests__QueryAPITests),
        testCase(QueryWriteAPITests.__allTests__QueryWriteAPITests),
        testCase(WriteAPITests.__allTests__WriteAPITests),
    ]
}
#endif
