//
// Created by Jakub Bednář on 13/11/2020.
//

import Foundation

@testable import InfluxDBSwift
import XCTest

final class PointTests: XCTestCase {
    func testMeasurementEscape() {
        var point = InfluxDBClient.Point("h2 o")
                .addTag(key: "location", value: "europe")
                .addTag(key: "", value: "warm")
                .addField(key: "level", value: .int(2))
        XCTAssertEqual("h2\\ o,location=europe level=2i", try point.toLineProtocol())

        point = InfluxDBClient.Point("h2,o")
                .addTag(key: "location", value: "europe")
                .addTag(key: "", value: "warn")
                .addField(key: "level", value: .int(2))

        XCTAssertEqual("h2\\,o,location=europe level=2i", try point.toLineProtocol())
    }

    func testTagEmptyKey() {
        let point = InfluxDBClient.Point("h2o")
                .addTag(key: "location", value: "europe")
                .addTag(key: "", value: "warn")
                .addField(key: "level", value: .int(2))

        XCTAssertEqual("h2o,location=europe level=2i", try point.toLineProtocol())
    }

    func testTagEmptyValue() {
        let point = InfluxDBClient.Point("h2o")
                .addTag(key: "location", value: "europe")
                .addTag(key: "log", value: "")
                .addField(key: "level", value: .int(2))

        XCTAssertEqual("h2o,location=europe level=2i", try point.toLineProtocol())
    }

    func testTagEscapingKeyAndValue() {
        let point = InfluxDBClient.Point("h\n2\ro\t_data")
                .addTag(key: "new\nline", value: "new\nline")
                .addTag(key: "carriage\rreturn", value: "carriage\nreturn")
                .addTag(key: "t\tab", value: "t\tab")
                .addField(key: "level", value: .int(2))

        XCTAssertEqual(
                "h\\n2\\ro\\t_data,carriage\\rreturn=carriage\\nreturn,new\\nline=new\\nline,t\\tab=t\\tab level=2i",
                try point.toLineProtocol())
    }

    func testEqualSignEscaping() {
        let point = InfluxDBClient.Point("h=2o")
                .addTag(key: "l=ocation", value: "e=urope")
                .addField(key: "l=evel", value: .int(2))

        XCTAssertEqual("h=2o,l\\=ocation=e\\=urope l\\=evel=2i", try point.toLineProtocol())
    }

    func testOverrideTagField() {
        let point = InfluxDBClient.Point("h2o")
                .addTag(key: "location", value: "europe")
                .addTag(key: "location", value: "europe2")
                .addField(key: "level", value: .int(2))
                .addField(key: "level", value: .int(3))

        XCTAssertEqual("h2o,location=europe2 level=3i", try point.toLineProtocol())
    }

    func testFieldTypes() {
        let point = InfluxDBClient.Point("h2o")
                .addTag(key: "location", value: "europe")
                .addField(key: "decimal", value: .int(123))
                .addField(key: "float", value: .double(250.69))
                .addField(key: "bool", value: .boolean(false))
                .addField(key: "string", value: .string("string value"))

        let expected = "h2o,location=europe bool=false,decimal=123i,float=250.69,string=\"string value\""

        XCTAssertEqual(expected, try point.toLineProtocol())
    }

    func testInt() {
        let aNumber: Int = 3
        let bNumber: Int8 = 6
        let cNumber: Int16 = 9
        let dNumber: Int32 = 12
        let eNumber: Int64 = 15

        let point = InfluxDBClient.Point("h2o")
                .addField(key: "a", value: .int(aNumber))
                .addField(key: "b", value: InfluxDBClient.Point.FieldValue(bNumber))
                .addField(key: "c", value: InfluxDBClient.Point.FieldValue(cNumber))
                .addField(key: "d", value: InfluxDBClient.Point.FieldValue(dNumber))
                .addField(key: "e", value: InfluxDBClient.Point.FieldValue(eNumber))

        XCTAssertEqual("h2o a=3i,b=6i,c=9i,d=12i,e=15i", try point.toLineProtocol())
    }

    func testUnsignedInt() {
        let aNumber: UInt = 3
        let bNumber: UInt8 = 6
        let cNumber: UInt16 = 9
        let dNumber: UInt32 = 12
        let eNumber: UInt64 = 15

        let point = InfluxDBClient.Point("h2o")
                .addField(key: "a", value: .uint(aNumber))
                .addField(key: "b", value: InfluxDBClient.Point.FieldValue(bNumber))
                .addField(key: "c", value: InfluxDBClient.Point.FieldValue(cNumber))
                .addField(key: "d", value: InfluxDBClient.Point.FieldValue(dNumber))
                .addField(key: "e", value: InfluxDBClient.Point.FieldValue(eNumber))

        XCTAssertEqual("h2o a=3u,b=6u,c=9u,d=12u,e=15u", try point.toLineProtocol())
    }

    func testFieldNullValue() {
        let point = InfluxDBClient.Point("h2o")
                .addTag(key: "location", value: "europe")
                .addField(key: "level", value: .int(2))
                .addField(key: "warning", value: nil)

        XCTAssertEqual("h2o,location=europe level=2i", try point.toLineProtocol())
    }

    func testFieldEscape() {
        var point = InfluxDBClient.Point("h2o")
                .addTag(key: "location", value: "europe")
                .addField(key: "level", value: .string("string esc\\ape value"))

        XCTAssertEqual("h2o,location=europe level=\"string esc\\\\ape value\"", try point.toLineProtocol())

        point = InfluxDBClient.Point("h2o")
                .addTag(key: "location", value: "europe")
                .addField(key: "level", value: .string("string esc\"ape value"))

        XCTAssertEqual("h2o,location=europe level=\"string esc\\\"ape value\"", try point.toLineProtocol())
    }

    func testTime() {
        let point = InfluxDBClient.Point("h2o")
                .addTag(key: "location", value: "europe")
                .addField(key: "level", value: .int(2))
                .time(time: .interval(123, .s))

        XCTAssertEqual("h2o,location=europe level=2i 123000000000", try point.toLineProtocol())
    }

    func testDateTimeFormatting() {
        var date = Date(2015, 10, 15, 8, 20, 15)

        var point = InfluxDBClient.Point("h2o")
                .addTag(key: "location", value: "europe")
                .addField(key: "level", value: .int(2))
                .time(time: .date(date))

        XCTAssertEqual("h2o,location=europe level=2i 1444897215000", try point.toLineProtocol(precision: .ms))

        date = Date(2015, 10, 15, 8, 20, 15, 0, TimeZone(abbreviation: "JST"))

        point = InfluxDBClient.Point("h2o")
                .addTag(key: "location", value: "europe")
                .addField(key: "level", value: .int(2))
                .time(time: .date(date))

        XCTAssertEqual("h2o,location=europe level=2i 1444864815000", try point.toLineProtocol(precision: .ms))

        date = Date(2015, 10, 15, 8, 20, 15, 750)

        point = InfluxDBClient.Point("h2o")
                .addTag(key: "location", value: "europe")
                .addField(key: "level", value: .boolean(false))
                .time(time: .date(date))

        XCTAssertEqual("h2o,location=europe level=false 1444897215", try point.toLineProtocol(precision: .s))

        point = InfluxDBClient.Point("h2o")
                .addTag(key: "location", value: "europe")
                .addField(key: "level", value: .boolean(false))
                .time(time: .date(date))

        XCTAssertEqual("h2o,location=europe level=false 1444897215000", try point.toLineProtocol(precision: .ms))

        point = InfluxDBClient.Point("h2o")
                .addTag(key: "location", value: "europe")
                .addField(key: "level", value: .boolean(false))
                .time(time: .date(date))

        XCTAssertEqual("h2o,location=europe level=false 1444897215000750", try point.toLineProtocol(precision: .us))

        point = InfluxDBClient.Point("h2o")
                .addTag(key: "location", value: "europe")
                .addField(key: "level", value: .boolean(false))
                .time(time: .date(date))

        XCTAssertEqual("h2o,location=europe level=false 1444897215000750080", try point.toLineProtocol(precision: .ns))

        point = InfluxDBClient.Point("h2o")
                .addTag(key: "location", value: "europe")
                .addField(key: "level", value: .boolean(true))
                .time(time: .date(Date()))

        XCTAssertFalse(try point.toLineProtocol(precision: .s)!.contains("."))
    }

    func testPointProtocol() {
        let date = Date(2009, 11, 10, 23, 0, 0)

        var point = InfluxDBClient.Point("weather")
                .time(time: .date(date))
                .addTag(key: "location", value: "Přerov")
                .addTag(key: "sid", value: "12345")
                .addField(key: "temperature", value: .double(30.1))
                .addField(key: "int_field", value: .int(2))
                .addField(key: "float_field", value: .int(0))

        XCTAssertEqual(
                "weather,location=Přerov,sid=12345 float_field=0i,int_field=2i,temperature=30.1 1257894000000",
                try point.toLineProtocol(precision: .ms))

        point = InfluxDBClient.Point("weather")
                .time(time: .date(date))
                .addField(key: "temperature", value: .double(30.1))
                .addField(key: "float_field", value: .int(0))

        XCTAssertEqual(
                "weather float_field=0i,temperature=30.1 1257894000000",
                try point.toLineProtocol(precision: .ms))
    }

    func testTimestamp() {
        let utc = Date(2009, 11, 10, 23, 0, 0, 0)
        let berlin = Date(2009, 11, 10, 23, 0, 0, 0, TimeZone(identifier: "Europe/Berlin"))

        let expUTC = "A val=1i 1257894000000000000"
        let expBerlin = "A val=1i 1257890400000000000"

        let point = InfluxDBClient.Point("A")
                .addField(key: "val", value: .int(1))
                .time(time: .date(utc))

        XCTAssertEqual(expUTC, try point.toLineProtocol())
        XCTAssertEqual(expUTC, try point.time(time: .date(utc)).toLineProtocol())
        XCTAssertEqual(expBerlin, try point.time(time: .date(berlin)).toLineProtocol())
    }

    func testInfinityValues() {
        let point = InfluxDBClient.Point("h2o")
                .addTag(key: "location", value: "europe")
                .addField(key: "decimal-infinity-positive", value: .double(Double.infinity))
                .addField(key: "decimal-infinity-negative", value: .double(-Double.infinity))
                .addField(key: "decimal-nan", value: .double(-Double.nan))
                .addField(key: "float-infinity-positive", value: InfluxDBClient.Point.FieldValue(Float.infinity))
                .addField(key: "float-infinity-negative", value: InfluxDBClient.Point.FieldValue(-Float.infinity))
                .addField(key: "float-nan", value: InfluxDBClient.Point.FieldValue(Float.nan))
                .addField(key: "level", value: .int(2))

        XCTAssertEqual("h2o,location=europe level=2i", try point.toLineProtocol())
    }

    func testOnlyInfinityValues() {
        let point = InfluxDBClient.Point("h2o")
                .addTag(key: "location", value: "europe")
                .addField(key: "decimal-infinity-positive", value: .double(Double.infinity))
                .addField(key: "decimal-infinity-negative", value: .double(-Double.infinity))
                .addField(key: "decimal-nan", value: .double(-Double.nan))
                .addField(key: "float-infinity-positive", value: InfluxDBClient.Point.FieldValue(Float.infinity))
                .addField(key: "float-infinity-negative", value: InfluxDBClient.Point.FieldValue(-Float.infinity))
                .addField(key: "float-nan", value: InfluxDBClient.Point.FieldValue(Float.nan))

        XCTAssertNil(try point.toLineProtocol())
    }

    func testPointsFromDifferentTimezones() throws {
        let utc = Date(2020, 7, 4, 0, 0, 0, 123456)
        let hongKong = Date(2020, 7, 4, 8, 0, 0, 123456, TimeZone(identifier: "Asia/Hong_Kong"))  // +08:00

        let pointUTC = try InfluxDBClient.Point("h2o")
                .addField(key: "val", value: .int(1))
                .time(time: .date(utc))
                .toLineProtocol()
        let pointHK = try InfluxDBClient.Point("h2o")
                .addField(key: "val", value: .int(1))
                .time(time: .date(hongKong))
                .toLineProtocol()
        XCTAssertEqual(pointUTC, pointHK)
    }

    func testFromTuple() throws {
        let aIntNumber: Int = 3
        let bIntNumber: Int8 = 6
        let cIntNumber: Int16 = 9
        let dIntNumber: Int32 = 12
        let eIntNumber: Int64 = 15

        let aUIntNumber: UInt = 3
        let bUIntNumber: UInt8 = 6
        let cUIntNumber: UInt16 = 9
        let dUIntNumber: UInt32 = 12
        let eUIntNumber: UInt64 = 15

        let tuples: [(InfluxDBClient.Point.Tuple, String)] = [
            (
                    (
                            measurement: "h2o_feet",
                            tags: ["location": "coyote_creek"],
                            fields: ["water_level": .double(1.0)],
                            time: .date(Date(2020, 10, 11, 0, 0, 0, 0))
                    ),
                    "h2o_feet,location=coyote_creek water_level=1.0 1602374400000000000"
            ),
            (
                    (
                            measurement: "h2o_feet",
                            tags: ["location": "coyote_creek"],
                            fields: ["water_level": .boolean(true)],
                            time: .date(Date(2020, 10, 11, 0, 0, 0, 0))
                    ),
                    "h2o_feet,location=coyote_creek water_level=true 1602374400000000000"
            ),
            (
                    (
                            measurement: "h2o_feet",
                            tags: ["location": "coyote_creek"],
                            fields: ["water_level": .string("good")],
                            time: .date(Date(2020, 10, 11, 0, 0, 0, 0))
                    ),
                    "h2o_feet,location=coyote_creek water_level=\"good\" 1602374400000000000"
            ),
            (
                    (
                            measurement: "h2o_feet",
                            tags: nil,
                            fields: ["water_level": .double(1.0)],
                            time: .date(Date(2020, 10, 11, 0, 0, 0, 0))
                    ),
                    "h2o_feet water_level=1.0 1602374400000000000"
            ),
            (
                    (
                            measurement: "h2o_feet",
                            tags: ["location": nil],
                            fields: ["water_level": .double(1.0)],
                            time: .date(Date(2020, 10, 11, 0, 0, 0, 0))
                    ),
                    "h2o_feet water_level=1.0 1602374400000000000"
            ),
            (
                    (
                            measurement: "h2o_feet",
                            tags: ["location": nil],
                            fields: ["water_level": .double(1.0)],
                            time: nil
                    ),
                    "h2o_feet water_level=1.0"
            )
        ]

        for tuple in tuples {
            XCTAssertEqual(tuple.1, try InfluxDBClient.Point.fromTuple(tuple.0).toLineProtocol())
        }

        let intTuple: InfluxDBClient.Point.Tuple = (
                measurement: "h2o_feet",
                tags: nil,
                fields: [
                    "aIntNumber": .int(aIntNumber),
                    "bIntNumber": InfluxDBClient.Point.FieldValue(bIntNumber),
                    "cIntNumber": InfluxDBClient.Point.FieldValue(cIntNumber),
                    "dIntNumber": InfluxDBClient.Point.FieldValue(dIntNumber),
                    "eIntNumber": InfluxDBClient.Point.FieldValue(eIntNumber)
                ],
                time: nil
        )

        XCTAssertEqual(
                "h2o_feet aIntNumber=3i,bIntNumber=6i,cIntNumber=9i,dIntNumber=12i,eIntNumber=15i",
                try InfluxDBClient.Point.fromTuple(intTuple).toLineProtocol())

        let uIntTuple: InfluxDBClient.Point.Tuple = (
                measurement: "h2o_feet",
                tags: nil,
                fields: [
                    "aUIntNumber": .uint(aUIntNumber),
                    "bUIntNumber": InfluxDBClient.Point.FieldValue(bUIntNumber),
                    "cUIntNumber": InfluxDBClient.Point.FieldValue(cUIntNumber),
                    "dUIntNumber": InfluxDBClient.Point.FieldValue(dUIntNumber),
                    "eUIntNumber": InfluxDBClient.Point.FieldValue(eUIntNumber)
                ],
                time: nil
        )

        XCTAssertEqual(
                "h2o_feet aUIntNumber=3u,bUIntNumber=6u,cUIntNumber=9u,dUIntNumber=12u,eUIntNumber=15u",
                try InfluxDBClient.Point.fromTuple(uIntTuple).toLineProtocol())
    }

    func testDescription() throws {
        let point = InfluxDBClient.Point("h2o")
                .addTag(key: "loc", value: "us")
                .addField(key: "value", value: .int(100))

        let required = "Point: measurement:h2o, tags:[\"loc\": Optional(\"us\")], "
                + "fields:[\"value\": Optional(InfluxDBSwift.InfluxDBClient.Point.FieldValue.int(100))], time:nil"
        XCTAssertEqual(required, point.description)
    }

    func testDefaultTags() throws {
        let point = InfluxDBClient.Point("h2o")
                .addTag(key: "loc", value: "us")
                .addTag(key: "in_default_tags", value: "use_this")
                .addField(key: "value", value: .int(100))

        let defaultTags = ["tag_a_key": "tag_a_value", "in_default_tags": "not_use_this", "a_tag": "a_tag_value"]

        XCTAssertEqual(
                "h2o,a_tag=a_tag_value,in_default_tags=use_this,loc=us,tag_a_key=tag_a_value value=100i",
                try point.toLineProtocol(defaultTags: defaultTags))
    }

    func testIntervalPrecision() throws {
        let expectations = [
            (
                    time: InfluxDBClient.Point.TimestampValue.interval(1556892576842902000, .ns),
                    records: [
                        "h2o level=1i 1556892576842902000",
                        "h2o level=1i 1556892576842902",
                        "h2o level=1i 1556892576842",
                        "h2o level=1i 1556892576"
                    ]
            ),
            (
                    time: InfluxDBClient.Point.TimestampValue.interval(1556892576842902, .us),
                    records: [
                        "h2o level=1i 1556892576842902000",
                        "h2o level=1i 1556892576842902",
                        "h2o level=1i 1556892576842",
                        "h2o level=1i 1556892576"
                    ]
            ),
            (
                    time: InfluxDBClient.Point.TimestampValue.interval(1556892576842, .ms),
                    records: [
                        "h2o level=1i 1556892576842000000",
                        "h2o level=1i 1556892576842000",
                        "h2o level=1i 1556892576842",
                        "h2o level=1i 1556892576"
                    ]
            ),
            (
                    time: InfluxDBClient.Point.TimestampValue.interval(1556892576, .s),
                    records: [
                        "h2o level=1i 1556892576000000000",
                        "h2o level=1i 1556892576000000",
                        "h2o level=1i 1556892576000",
                        "h2o level=1i 1556892576"
                    ]
            )
        ]

        try expectations.forEach { expectation in
            let point = InfluxDBClient.Point("h2o")
                    .addField(key: "level", value: .int(1))
                    .time(time: expectation.time)

            XCTAssertEqual(expectation.records[0], try point.toLineProtocol(precision: .ns))
            XCTAssertEqual(expectation.records[1], try point.toLineProtocol(precision: .us))
            XCTAssertEqual(expectation.records[2], try point.toLineProtocol(precision: .ms))
            XCTAssertEqual(expectation.records[3], try point.toLineProtocol(precision: .s))
        }
    }
}

internal extension Date {
    init(_ year: Int,
         _ month: Int,
         _ day: Int,
         _ hour: Int = 0,
         _ minute: Int = 0,
         _ second: Int = 0,
         _ microsecond: Int = 0,
         _ timeZone: TimeZone? = nil) {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = second
        dateComponents.nanosecond = microsecond * 1000
        dateComponents.timeZone = timeZone ?? OpenISO8601DateFormatter.utcTimeZone

        var utcCalendar = Calendar.current
        let zone: TimeZone = dateComponents.timeZone!
        utcCalendar.timeZone = zone

        let date = utcCalendar.date(from: dateComponents)!
        self.init(timeInterval: 0, since: date)
    }
}
