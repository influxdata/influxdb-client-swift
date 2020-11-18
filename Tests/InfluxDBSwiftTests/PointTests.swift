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
                .addField(key: "level", value: 2)
        XCTAssertEqual("h2\\ o,location=europe level=2i", try point.toLineProtocol())

        point = InfluxDBClient.Point("h2,o")
                .addTag(key: "location", value: "europe")
                .addTag(key: "", value: "warn")
                .addField(key: "level", value: 2)

        XCTAssertEqual("h2\\,o,location=europe level=2i", try point.toLineProtocol())
    }

    func testTagEmptyKey() {
        let point = InfluxDBClient.Point("h2o")
                .addTag(key: "location", value: "europe")
                .addTag(key: "", value: "warn")
                .addField(key: "level", value: 2)

        XCTAssertEqual("h2o,location=europe level=2i", try point.toLineProtocol())
    }

    func testTagEmptyValue() {
        let point = InfluxDBClient.Point("h2o")
                .addTag(key: "location", value: "europe")
                .addTag(key: "log", value: "")
                .addField(key: "level", value: 2)

        XCTAssertEqual("h2o,location=europe level=2i", try point.toLineProtocol())
    }

    func testTagEscapingKeyAndValue() {
        let point = InfluxDBClient.Point("h\n2\ro\t_data")
                .addTag(key: "new\nline", value: "new\nline")
                .addTag(key: "carriage\rreturn", value: "carriage\nreturn")
                .addTag(key: "t\tab", value: "t\tab")
                .addField(key: "level", value: 2)

        XCTAssertEqual(
                "h\\n2\\ro\\t_data,carriage\\rreturn=carriage\\nreturn,new\\nline=new\\nline,t\\tab=t\\tab level=2i",
                try point.toLineProtocol())
    }

    func testEqualSignEscaping() {
        let point = InfluxDBClient.Point("h=2o")
                .addTag(key: "l=ocation", value: "e=urope")
                .addField(key: "l=evel", value: 2)

        XCTAssertEqual("h=2o,l\\=ocation=e\\=urope l\\=evel=2i", try point.toLineProtocol())
    }

    func testOverrideTagField() {
        let point = InfluxDBClient.Point("h2o")
                .addTag(key: "location", value: "europe")
                .addTag(key: "location", value: "europe2")
                .addField(key: "level", value: 2)
                .addField(key: "level", value: 3)

        XCTAssertEqual("h2o,location=europe2 level=3i", try point.toLineProtocol())
    }

    func testFieldTypes() {
        let point = InfluxDBClient.Point("h2o")
                .addTag(key: "location", value: "europe")
                .addField(key: "decimal", value: 123)
                .addField(key: "float", value: 250.69)
                .addField(key: "bool", value: false)
                .addField(key: "string", value: "string value")

        let expected = "h2o,location=europe bool=false,decimal=123i,float=250.69,string=\"string value\""

        XCTAssertEqual(expected, try point.toLineProtocol())
    }

    func testFieldNullValue() {
        let point = InfluxDBClient.Point("h2o")
                .addTag(key: "location", value: "europe")
                .addField(key: "level", value: 2)
                .addField(key: "warning", value: nil)

        XCTAssertEqual("h2o,location=europe level=2i", try point.toLineProtocol())
    }

    func testFieldEscape() {
        var point = InfluxDBClient.Point("h2o")
                .addTag(key: "location", value: "europe")
                .addField(key: "level", value: "string esc\\ape value")

        XCTAssertEqual("h2o,location=europe level=\"string esc\\\\ape value\"", try point.toLineProtocol())

        point = InfluxDBClient.Point("h2o")
                .addTag(key: "location", value: "europe")
                .addField(key: "level", value: "string esc\"ape value")

        XCTAssertEqual("h2o,location=europe level=\"string esc\\\"ape value\"", try point.toLineProtocol())
    }

    func testTime() {
        let point = InfluxDBClient.Point("h2o")
                .addTag(key: "location", value: "europe")
                .addField(key: "level", value: 2)
                .time(time: 123, precision: InfluxDBClient.WritePrecision.s)

        XCTAssertEqual("h2o,location=europe level=2i 123", try point.toLineProtocol())
    }

    func testTimePrecisionDefault() {
        let point = InfluxDBClient.Point("h2o")
                .addTag(key: "location", value: "europe")
                .addField(key: "level", value: 2)

        XCTAssertEqual(InfluxDBClient.WritePrecision.ns, point.precision)
    }

    func testDateTimeFormatting() {
        var date = Date(2015, 10, 15, 8, 20, 15)

        var point = InfluxDBClient.Point("h2o")
                .addTag(key: "location", value: "europe")
                .addField(key: "level", value: 2)
                .time(time: date, precision: InfluxDBClient.WritePrecision.ms)

        XCTAssertEqual("h2o,location=europe level=2i 1444897215000", try point.toLineProtocol())

        date = Date(2015, 10, 15, 8, 20, 15, 0, TimeZone(abbreviation: "JST"))

        point = InfluxDBClient.Point("h2o")
                .addTag(key: "location", value: "europe")
                .addField(key: "level", value: 2)
                .time(time: date, precision: InfluxDBClient.WritePrecision.ms)

        XCTAssertEqual("h2o,location=europe level=2i 1444864815000", try point.toLineProtocol())

        date = Date(2015, 10, 15, 8, 20, 15, 750)

        point = InfluxDBClient.Point("h2o")
                .addTag(key: "location", value: "europe")
                .addField(key: "level", value: false)
                .time(time: date, precision: InfluxDBClient.WritePrecision.s)

        XCTAssertEqual("h2o,location=europe level=false 1444897215", try point.toLineProtocol())

        point = InfluxDBClient.Point("h2o")
                .addTag(key: "location", value: "europe")
                .addField(key: "level", value: false)
                .time(time: date, precision: InfluxDBClient.WritePrecision.ms)

        XCTAssertEqual("h2o,location=europe level=false 1444897215000", try point.toLineProtocol())

        point = InfluxDBClient.Point("h2o")
                .addTag(key: "location", value: "europe")
                .addField(key: "level", value: false)
                .time(time: date, precision: InfluxDBClient.WritePrecision.us)

        XCTAssertEqual("h2o,location=europe level=false 1444897215000750", try point.toLineProtocol())

        point = InfluxDBClient.Point("h2o")
                .addTag(key: "location", value: "europe")
                .addField(key: "level", value: false)
                .time(time: date, precision: InfluxDBClient.WritePrecision.ns)

        XCTAssertEqual("h2o,location=europe level=false 1444897215000750080", try point.toLineProtocol())

        point = InfluxDBClient.Point("h2o")
                .addTag(key: "location", value: "europe")
                .addField(key: "level", value: true)
                .time(time: Date(), precision: InfluxDBClient.WritePrecision.s)

        XCTAssertFalse(try point.toLineProtocol()!.contains("."))
    }

    func testPointProtocol() {
        let date = Date(2009, 11, 10, 23, 0, 0)

        var point = InfluxDBClient.Point("weather")
                .time(time: date, precision: InfluxDBClient.WritePrecision.ms)
                .addTag(key: "location", value: "Přerov")
                .addTag(key: "sid", value: "12345")
                .addField(key: "temperature", value: 30.1)
                .addField(key: "int_field", value: 2)
                .addField(key: "float_field", value: 0)

        XCTAssertEqual(
                "weather,location=Přerov,sid=12345 float_field=0i,int_field=2i,temperature=30.1 1257894000000",
                try point.toLineProtocol())

        point = InfluxDBClient.Point("weather")
                .time(time: date, precision: InfluxDBClient.WritePrecision.ms)
                .addField(key: "temperature", value: 30.1)
                .addField(key: "float_field", value: 0)

        XCTAssertEqual("weather float_field=0i,temperature=30.1 1257894000000", try point.toLineProtocol())
    }

    func testTimestamp() {
        let utc = Date(2009, 11, 10, 23, 0, 0, 0)
        let berlin = Date(2009, 11, 10, 23, 0, 0, 0, TimeZone(identifier: "Europe/Berlin"))

        let expUTC = "A val=1i 1257894000000000000"
        let expBerlin = "A val=1i 1257890400000000000"

        let point = InfluxDBClient.Point("A").addField(key: "val", value: 1).time(time: utc)

        XCTAssertEqual(expUTC, try point.toLineProtocol())
        XCTAssertEqual(expUTC, try point.time(time: utc).toLineProtocol())
        XCTAssertEqual(expBerlin, try point.time(time: berlin).toLineProtocol())
    }

    func testInfinityValues() {
        let point = InfluxDBClient.Point("h2o")
                .addTag(key: "location", value: "europe")
                .addField(key: "decimal-infinity-positive", value: Double.infinity)
                .addField(key: "decimal-infinity-negative", value: -Double.infinity)
                .addField(key: "decimal-nan", value: -Double.nan)
                .addField(key: "float-infinity-positive", value: Float.infinity)
                .addField(key: "float-infinity-negative", value: -Float.infinity)
                .addField(key: "float-nan", value: Float.nan)
                .addField(key: "level", value: 2)

        XCTAssertEqual("h2o,location=europe level=2i", try point.toLineProtocol())
    }

    func testOnlyInfinityValues() {
        let point = InfluxDBClient.Point("h2o")
                .addTag(key: "location", value: "europe")
                .addField(key: "decimal-infinity-positive", value: Double.infinity)
                .addField(key: "decimal-infinity-negative", value: -Double.infinity)
                .addField(key: "decimal-nan", value: -Double.nan)
                .addField(key: "float-infinity-positive", value: Float.infinity)
                .addField(key: "float-infinity-negative", value: -Float.infinity)
                .addField(key: "float-nan", value: Float.nan)

        XCTAssertNil(try point.toLineProtocol())
    }

    func testPointsFromDifferentTimezones() throws {
        let utc = Date(2020, 7, 4, 0, 0, 0, 123456)
        let hongKong = Date(2020, 7, 4, 8, 0, 0, 123456, TimeZone(identifier: "Asia/Hong_Kong"))  // +08:00

        let pointUTC = try InfluxDBClient.Point("h2o")
                .addField(key: "val", value: 1)
                .time(time: utc)
                .toLineProtocol()
        let pointHK = try InfluxDBClient.Point("h2o")
                .addField(key: "val", value: 1)
                .time(time: hongKong)
                .toLineProtocol()
        XCTAssertEqual(pointUTC, pointHK)
    }

    func testFromTuple() throws {
        let tuples: [
        (
                (measurement: String, tags: [String?: String?]?, fields: [String?: Any?], time: Any?),
                InfluxDBClient.WritePrecision?,
                String
        )] = [
            (
                    (
                            measurement: "h2o_feet",
                            tags: ["location": "coyote_creek"],
                            fields: ["water_level": 1.0],
                            time: Date(2020, 10, 11, 0, 0, 0, 0)
                    ),
                    nil,
                    "h2o_feet,location=coyote_creek water_level=1.0 1602374400000000000"
            ),
            (
                    (
                            measurement: "h2o_feet",
                            tags: ["location": "coyote_creek"],
                            fields: ["water_level": 1.0],
                            time: Date(2020, 10, 11, 0, 0, 0, 0)
                    ),
                    InfluxDBClient.WritePrecision.s,
                    "h2o_feet,location=coyote_creek water_level=1.0 1602374400"
            ),
            (
                    (
                            measurement: "h2o_feet",
                            tags: nil,
                            fields: ["water_level": 1.0],
                            time: Date(2020, 10, 11, 0, 0, 0, 0)
                    ),
                    nil,
                    "h2o_feet water_level=1.0 1602374400000000000"
            ),
            (
                    (
                            measurement: "h2o_feet",
                            tags: ["location": nil],
                            fields: ["water_level": 1.0],
                            time: Date(2020, 10, 11, 0, 0, 0, 0)
                    ),
                    nil,
                    "h2o_feet water_level=1.0 1602374400000000000"
            ),
            (
                    (
                            measurement: "h2o_feet",
                            tags: ["location": nil],
                            fields: ["water_level": 1.0],
                            time: nil
                    ),
                    nil,
                    "h2o_feet water_level=1.0"
            )
        ]

        for tuple in tuples {
            XCTAssertEqual(
                tuple.2,
                try InfluxDBClient.Point.fromTuple(tuple.0, precision: tuple.1).toLineProtocol())
        }
    }
}

private extension Date {
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
        dateComponents.timeZone = timeZone ?? TimeZone(abbreviation: "UTC")

        var utcCalendar = Calendar.current
        let zone: TimeZone = dateComponents.timeZone!
        utcCalendar.timeZone = zone

        let date = utcCalendar.date(from: dateComponents)!
        self.init(timeInterval: 0, since: date)
    }
}
