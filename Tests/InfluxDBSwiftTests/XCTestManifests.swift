#if !canImport(ObjectiveC)
import XCTest

extension AAJunitReportInitializerTest {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__AAJunitReportInitializerTest = [
        ("testInit", testInit),
    ]
}

extension DeleteAPITests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__DeleteAPITests = [
        ("testBucketIDOrgIDParameters", testBucketIDOrgIDParameters),
        ("testBucketOrgParameters", testBucketOrgParameters),
        ("testErrorResponse", testErrorResponse),
        ("testGetDeleteAPI", testGetDeleteAPI),
        ("testPredicateRequestSerialization", testPredicateRequestSerialization),
        ("testWithoutBucketOrgParameters", testWithoutBucketOrgParameters),
    ]
}

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

extension IntegrationTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__IntegrationTests = [
        ("testDelete", testDelete),
        ("testQueryWriteIntegration", testQueryWriteIntegration),
    ]
}

extension PointSettingsTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__PointSettingsTests = [
        ("testCreate", testCreate),
        ("testEvaluate", testEvaluate),
        ("testNilValue", testNilValue),
        ("testNotExistEnv", testNotExistEnv),
    ]
}

extension PointTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__PointTests = [
        ("testDateTimeFormatting", testDateTimeFormatting),
        ("testDefaultTags", testDefaultTags),
        ("testDescription", testDescription),
        ("testEqualSignEscaping", testEqualSignEscaping),
        ("testFieldEscape", testFieldEscape),
        ("testFieldNullValue", testFieldNullValue),
        ("testFieldTypes", testFieldTypes),
        ("testFromTuple", testFromTuple),
        ("testInfinityValues", testInfinityValues),
        ("testInt", testInt),
        ("testMeasurementEscape", testMeasurementEscape),
        ("testOnlyInfinityValues", testOnlyInfinityValues),
        ("testOverrideTagField", testOverrideTagField),
        ("testPointProtocol", testPointProtocol),
        ("testPointsFromDifferentTimezones", testPointsFromDifferentTimezones),
        ("testTagEmptyKey", testTagEmptyKey),
        ("testTagEmptyValue", testTagEmptyValue),
        ("testTagEscapingKeyAndValue", testTagEscapingKeyAndValue),
        ("testTime", testTime),
        ("testTimestamp", testTimestamp),
        ("testUnsignedInt", testUnsignedInt),
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

extension WriteAPITests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__WriteAPITests = [
        ("testBucketAndOrgAreRequired", testBucketAndOrgAreRequired),
        ("testDefaultTags", testDefaultTags),
        ("testMakeWriteAPI", testMakeWriteAPI),
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
        testCase(AAJunitReportInitializerTest.__allTests__AAJunitReportInitializerTest),
        testCase(DeleteAPITests.__allTests__DeleteAPITests),
        testCase(FluxCSVParserTests.__allTests__FluxCSVParserTests),
        testCase(InfluxDBClientTests.__allTests__InfluxDBClientTests),
        testCase(InfluxDBErrorTests.__allTests__InfluxDBErrorTests),
        testCase(IntegrationTests.__allTests__IntegrationTests),
        testCase(PointSettingsTests.__allTests__PointSettingsTests),
        testCase(PointTests.__allTests__PointTests),
        testCase(QueryAPITests.__allTests__QueryAPITests),
        testCase(WriteAPITests.__allTests__WriteAPITests),
    ]
}
#endif
