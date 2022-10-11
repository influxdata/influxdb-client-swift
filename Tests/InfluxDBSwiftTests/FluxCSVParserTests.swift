//
// Created by Jakub Bednář on 01/12/2020.
//

import Foundation

@testable import InfluxDBSwift
import XCTest

final class FluxCSVParserTests: XCTestCase {
    // swiftlint:disable line_length trailing_whitespace
    func testResponseWithMultipleValues() throws {
        let data = """
                   #datatype,string,long,dateTime:RFC3339,dateTime:RFC3339,string,string,string,string,long,long,string
                   #group,false,false,true,true,true,true,true,true,false,false,false
                   #default,_result,,,,,,,,,,
                   ,result,table,_start,_stop,_field,_measurement,host,region,_value2,value1,value_str
                   ,,0,1677-09-21T00:12:43.145224192Z,2018-07-16T11:21:02.547596934Z,free,mem,A,west,121,11,test
                   ,,1,1677-09-21T00:12:43.145224192Z,2018-07-16T11:21:02.547596934Z,free,mem,B,west,484,22,test
                   ,,2,1677-09-21T00:12:43.145224192Z,2018-07-16T11:21:02.547596934Z,usage_system,cpu,A,west,1444,38,test
                   ,,3,1677-09-21T00:12:43.145224192Z,2018-07-16T11:21:02.547596934Z,user_usage,cpu,A,west,2401,49,test
                   """

        let tuples = try parse(data: data)
        XCTAssertEqual(4, tuples.count)

        // Group
        let table: QueryAPI.FluxTable = tuples[0].table
        XCTAssertEqual(false, table.columns[0].group)
        XCTAssertEqual(false, table.columns[1].group)
        XCTAssertEqual(true, table.columns[2].group)
        XCTAssertEqual(true, table.columns[3].group)
        XCTAssertEqual(true, table.columns[4].group)
        XCTAssertEqual(true, table.columns[5].group)
        XCTAssertEqual(true, table.columns[6].group)
        XCTAssertEqual(true, table.columns[7].group)
        XCTAssertEqual(false, table.columns[8].group)
        XCTAssertEqual(false, table.columns[9].group)

        // Record 1
        var record = tuples[0].record
        XCTAssertEqual(11, record.values.count)
        XCTAssertEqual("A", record.values["host"] as? String)
        XCTAssertEqual(121, record.values["_value2"] as? Int64)
        XCTAssertEqual(11, record.values["value1"] as? Int64)
        XCTAssertEqual("test", record.values["value_str"] as? String)

        // Record 2
        record = tuples[1].record
        XCTAssertEqual(11, record.values.count)
        XCTAssertEqual("B", record.values["host"] as? String)
        XCTAssertEqual(484, record.values["_value2"] as? Int64)
        XCTAssertEqual(22, record.values["value1"] as? Int64)
        XCTAssertEqual("test", record.values["value_str"] as? String)

        // Record 3
        record = tuples[2].record
        XCTAssertEqual(11, record.values.count)
        XCTAssertEqual("A", record.values["host"] as? String)
        XCTAssertEqual(1444, record.values["_value2"] as? Int64)
        XCTAssertEqual(38, record.values["value1"] as? Int64)
        XCTAssertEqual("test", record.values["value_str"] as? String)

        // Record 4
        record = tuples[3].record
        XCTAssertEqual(11, record.values.count)
        XCTAssertEqual("A", record.values["host"] as? String)
        XCTAssertEqual(2401, record.values["_value2"] as? Int64)
        XCTAssertEqual(49, record.values["value1"] as? Int64)
        XCTAssertEqual("test", record.values["value_str"] as? String)
    }

    func testShortcut() throws {
        let data = """
                   #datatype,string,long,dateTime:RFC3339,dateTime:RFC3339,dateTime:RFC3339,long,string,string,string,boolean
                   #group,false,false,false,false,false,false,false,false,false,true
                   #default,_result,,,,,,,,,true
                   ,result,table,_start,_stop,_time,_value,_field,_measurement,host,value
                   ,,0,1970-01-01T00:00:10Z,1970-01-01T00:00:20Z,1970-01-01T00:00:10Z,10,free,mem,A,true
                   """

        let records = try parse_to_records(data: data)
        XCTAssertEqual(1, records.count)

        let record: QueryAPI.FluxRecord = records[0]
        XCTAssertEqual(Date(1970, 01, 01, 0, 0, 10), record.values["_start"] as? Date)
        XCTAssertEqual(Date(1970, 01, 01, 0, 0, 20), record.values["_stop"] as? Date)
        XCTAssertEqual(Date(1970, 01, 01, 0, 0, 10), record.values["_time"] as? Date)
        XCTAssertEqual(10, record.values["_value"] as? Int64)
        XCTAssertEqual("free", record.values["_field"] as? String)
        XCTAssertEqual("mem", record.values["_measurement"] as? String)
        XCTAssertEqual("A", record.values["host"] as? String)
        XCTAssertEqual(true, record.values["value"] as? Bool)
    }

    func testMappingBoolean() throws {
        let data = """
                   #datatype,string,long,dateTime:RFC3339,dateTime:RFC3339,dateTime:RFC3339,long,string,string,string,boolean
                   #group,false,false,false,false,false,false,false,false,false,true
                   #default,_result,,,,,,,,,true
                   ,result,table,_start,_stop,_time,_value,_field,_measurement,host,value
                   ,,0,1970-01-01T00:00:10Z,1970-01-01T00:00:20Z,1970-01-01T00:00:10Z,10,free,mem,A,true
                   ,,0,1970-01-01T00:00:10Z,1970-01-01T00:00:20Z,1970-01-01T00:00:10Z,10,free,mem,A,false
                   ,,0,1970-01-01T00:00:10Z,1970-01-01T00:00:20Z,1970-01-01T00:00:10Z,10,free,mem,A,x
                   ,,0,1970-01-01T00:00:10Z,1970-01-01T00:00:20Z,1970-01-01T00:00:10Z,10,free,mem,A,
                   """

        let records = try parse_to_records(data: data)
        XCTAssertEqual(true, records[0].values["value"] as? Bool)
        XCTAssertEqual(false, records[1].values["value"] as? Bool)
        XCTAssertEqual(false, records[2].values["value"] as? Bool)
        XCTAssertEqual(true, records[3].values["value"] as? Bool)
    }

    func testMappingUnsignedLong() throws {
        let data = """
                   #datatype,string,long,dateTime:RFC3339,dateTime:RFC3339,dateTime:RFC3339,long,string,string,string,unsignedLong
                   #group,false,false,false,false,false,false,false,false,false,true
                   #default,_result,,,,,,,,,
                   ,result,table,_start,_stop,_time,_value,_field,_measurement,host,value
                   ,,0,1970-01-01T00:00:10Z,1970-01-01T00:00:20Z,1970-01-01T00:00:10Z,10,free,mem,A,17916881237904312345
                   ,,0,1970-01-01T00:00:10Z,1970-01-01T00:00:20Z,1970-01-01T00:00:10Z,10,free,mem,A,
                   """

        let records = try parse_to_records(data: data)

        XCTAssertEqual(17916881237904312345, records[0].values["value"] as? UInt64)
        XCTAssertNil(records[1].values["value"])
    }

    func testMappingDouble() throws {
        let data = """
                   #datatype,string,long,dateTime:RFC3339,dateTime:RFC3339,dateTime:RFC3339,long,string,string,string,double
                   #group,false,false,false,false,false,false,false,false,false,true
                   #default,_result,,,,,,,,,
                   ,result,table,_start,_stop,_time,_value,_field,_measurement,host,value
                   ,,0,1970-01-01T00:00:10Z,1970-01-01T00:00:20Z,1970-01-01T00:00:10Z,10,free,mem,A,12.25
                   ,,0,1970-01-01T00:00:10Z,1970-01-01T00:00:20Z,1970-01-01T00:00:10Z,10,free,mem,A,
                   """

        let records = try parse_to_records(data: data)
        XCTAssertEqual(12.25, records[0].values["value"] as? Double)
        XCTAssertNil(records[1].values["value"])
    }

    func testMappingBase64Binary() throws {
        let encodedString: String = "test value".data(using: .utf8)!.base64EncodedString()
        let data = """
                   #datatype,string,long,dateTime:RFC3339,dateTime:RFC3339,dateTime:RFC3339,long,string,string,string,base64Binary
                   #group,false,false,false,false,false,false,false,false,false,true
                   #default,_result,,,,,,,,,
                   ,result,table,_start,_stop,_time,_value,_field,_measurement,host,value
                   ,,0,1970-01-01T00:00:10Z,1970-01-01T00:00:20Z,1970-01-01T00:00:10Z,10,free,mem,A,\(encodedString)
                   ,,0,1970-01-01T00:00:10Z,1970-01-01T00:00:20Z,1970-01-01T00:00:10Z,10,free,mem,A,
                   """

        let records = try parse_to_records(data: data)

        let value: Any? = records[0].values["value"]
        XCTAssertEqual("test value", String(data: (value! as? Data) ?? Data(count: 0), encoding: .utf8))
        XCTAssertEqual(0, (records[1].values["value"] as? Data ?? Data(count: 1)).count)
    }

    func testMappingRFC3339() throws {
        let data = """
                   #datatype,string,long,dateTime:RFC3339,dateTime:RFC3339,dateTime:RFC3339,long,string,string,string,dateTime:RFC3339
                   #group,false,false,false,false,false,false,false,false,false,true
                   #default,_result,,,,,,,,,
                   ,result,table,_start,_stop,_time,_value,_field,_measurement,host,value
                   ,,0,1970-01-01T00:00:10Z,1970-01-01T00:00:20Z,1970-01-01T00:00:10Z,10,free,mem,A,1970-01-01T00:00:10Z
                   ,,0,1970-01-01T00:00:10Z,1970-01-01T00:00:20Z,1970-01-01T00:00:10Z,10,free,mem,A,
                   """

        let records = try parse_to_records(data: data)
        XCTAssertEqual(Date(1970, 01, 01, 00, 00, 10), records[0].values["value"] as? Date)
        XCTAssertNil(records[1].values["value"])
    }

    func testMappingRFC3339Nano() throws {
        let data = """
                   #datatype,string,long,dateTime:RFC3339,dateTime:RFC3339,dateTime:RFC3339,long,string,string,string,dateTime:RFC3339Nano
                   #group,false,false,false,false,false,false,false,false,false,true
                   #default,_result,,,,,,,,,
                   ,result,table,_start,_stop,_time,_value,_field,_measurement,host,value
                   ,,0,1970-01-01T00:00:10Z,1970-01-01T00:00:20Z,1970-01-01T00:00:10Z,10,free,mem,A,1970-01-01T00:00:10.999999999Z
                   ,,0,1970-01-01T00:00:10Z,1970-01-01T00:00:20Z,1970-01-01T00:00:10Z,10,free,mem,A,
                   """

        let records = try parse_to_records(data: data)

        let calendar = OpenISO8601DateFormatter.withoutSeconds.calendar!

        guard let date = records[0].values["value"] as? Date else {
            XCTFail("Date is not specified for: \(records[0])")
            return
        }

        let components: DateComponents = calendar.dateComponents(in: OpenISO8601DateFormatter.utcTimeZone, from: date)
        XCTAssertEqual(1970, components.year)
        XCTAssertEqual(1, components.month)
        XCTAssertEqual(1, components.day)
        XCTAssertEqual(0, components.hour)
        XCTAssertEqual(0, components.minute)
        XCTAssertEqual(10, components.second)
        XCTAssertNotNil(components.nanosecond)
        XCTAssertGreaterThan(components.nanosecond!, 990_000_000)
        XCTAssertNil(records[1].values["value"])
    }

    func testMappingDuration() throws {
        let data = """
                   #datatype,string,long,dateTime:RFC3339,dateTime:RFC3339,dateTime:RFC3339,long,string,string,string,duration
                   #group,false,false,false,false,false,false,false,false,false,true
                   #default,_result,,,,,,,,,
                   ,result,table,_start,_stop,_time,_value,_field,_measurement,host,value
                   ,,0,1970-01-01T00:00:10Z,1970-01-01T00:00:20Z,1970-01-01T00:00:10Z,10,free,mem,A,125
                   ,,0,1970-01-01T00:00:10Z,1970-01-01T00:00:20Z,1970-01-01T00:00:10Z,10,free,mem,A,
                   """

        let records = try parse_to_records(data: data)

        XCTAssertEqual(125, records[0].values["value"] as? Int64)
        XCTAssertNil(records[1].values["value"])
    }

    func testGroupKey() throws {
        let data = """
                   #datatype,string,long,dateTime:RFC3339,dateTime:RFC3339,dateTime:RFC3339,long,string,string,string,duration
                   #group,false,false,false,false,true,false,false,false,false,true
                   #default,_result,,,,,,,,,
                   ,result,table,_start,_stop,_time,_value,_field,_measurement,host,value
                   ,,0,1970-01-01T00:00:10Z,1970-01-01T00:00:20Z,1970-01-01T00:00:10Z,10,free,mem,A,125
                   ,,0,1970-01-01T00:00:10Z,1970-01-01T00:00:20Z,1970-01-01T00:00:10Z,10,free,mem,A,
                   """

        let tuples = try parse(data: data)

        XCTAssertEqual(10, tuples[0].table.columns.count)
        XCTAssertEqual(2, tuples[0].table.columns.filter {
                    $0.group
                }
                .count)
    }

    func testUnknownTypeAsString() throws {
        let data = """
                   #datatype,string,long,dateTime:RFC3339,dateTime:RFC3339,dateTime:RFC3339,long,string,string,string,unknown
                   #group,false,false,false,false,false,false,false,false,false,true
                   #default,_result,,,,,,,,,
                   ,result,table,_start,_stop,_time,_value,_field,_measurement,host,value
                   ,,0,1970-01-01T00:00:10Z,1970-01-01T00:00:20Z,1970-01-01T00:00:10Z,10,free,mem,A,12.25
                   ,,0,1970-01-01T00:00:10Z,1970-01-01T00:00:20Z,1970-01-01T00:00:10Z,10,free,mem,A,
                   """

        let records = try parse_to_records(data: data)
        XCTAssertEqual("12.25", records[0].values["value"] as? String)
        XCTAssertEqual("", records[1].values["value"] as? String)
    }

    func testError() {
        let data = """
                   #datatype,string,string
                   #group,true,true
                   #default,,
                   ,error,reference
                   ,failed to create physical plan: invalid time bounds from procedure from: bounds contain zero time,897
                   """

        let expected = "(897) Reason: failed to create physical plan: invalid time bounds from procedure from: bounds contain zero time"
        XCTAssertThrowsError(try parse_to_records(data: data)) { error in
            if let error = error as? InfluxDBClient.InfluxDBError {
                XCTAssertEqual(expected, error.description)
            } else {
                XCTFail("Unexpected type of error: \(type(of: error))")
            }
        }
    }

    func testErrorWithoutReference() {
        let data = """
                   #datatype,string,string
                   #group,true,true
                   #default,,
                   ,error,reference
                   ,failed to create physical plan: invalid time bounds from procedure from: bounds contain zero time,
                   """

        let expected = "(0) Reason: failed to create physical plan: invalid time bounds from procedure from: bounds contain zero time"
        XCTAssertThrowsError(try parse_to_records(data: data)) { error in
            if let error = error as? InfluxDBClient.InfluxDBError {
                XCTAssertEqual(expected, error.description)
            } else {
                XCTFail("Unexpected type of error: \(type(of: error))")
            }
        }
    }

    func testWithoutTableDefinition() {
        let data = """
                   ,result,table,_start,_stop,_time,_value,_field,_measurement,host,value
                   ,,0,1970-01-01T00:00:10Z,1970-01-01T00:00:20Z,1970-01-01T00:00:10Z,10,free,mem,A,12.25
                   ,,0,1970-01-01T00:00:10Z,1970-01-01T00:00:20Z,1970-01-01T00:00:10Z,10,free,mem,A,
                   """

        let expected = "Unable to parse CSV response. FluxTable definition was not found."
        XCTAssertThrowsError(try parse_to_records(data: data)) { error in
            if let error = error as? InfluxDBClient.InfluxDBError {
                XCTAssertEqual(expected, error.description)
            } else {
                XCTFail("Unexpected type of error: \(type(of: error))")
            }
        }
    }

    func testMultipleQueries() throws {
        let data = """
                   #datatype,string,long,string,string,dateTime:RFC3339,dateTime:RFC3339,dateTime:RFC3339,double,string
                   #group,false,false,true,true,true,true,false,false,true
                   #default,t1,,,,,,,,
                   ,result,table,_field,_measurement,_start,_stop,_time,_value,tag
                   ,,0,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:20:00Z,2,test1
                   ,,0,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:21:40Z,2,test1
                   ,,0,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:23:20Z,2,test1
                   ,,0,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:25:00Z,2,test1
                   ,,0,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:26:40Z,2,test1
                   ,,0,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:28:20Z,2,test1
                   ,,0,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:30:00Z,2,test1
                   ,,1,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:20:00Z,2,test2
                   ,,1,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:21:40Z,2,test2
                   ,,1,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:23:20Z,2,test2
                   ,,1,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:25:00Z,2,test2
                   ,,1,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:26:40Z,2,test2
                   ,,1,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:28:20Z,2,test2
                   ,,1,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:30:00Z,2,test2

                   #datatype,string,long,string,string,dateTime:RFC3339,dateTime:RFC3339,dateTime:RFC3339,double,string
                   #group,false,false,true,true,true,true,false,false,true
                   #default,t2,,,,,,,,
                   ,result,table,_field,_measurement,_start,_stop,_time,_value,tag
                   ,,0,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:20:00Z,2,test1
                   ,,0,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:21:40Z,2,test1
                   ,,0,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:23:20Z,2,test1
                   ,,0,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:25:00Z,2,test1
                   ,,0,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:26:40Z,2,test1
                   ,,0,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:28:20Z,2,test1
                   ,,0,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:30:00Z,2,test1
                   ,,1,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:20:00Z,2,test2
                   ,,1,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:21:40Z,2,test2
                   ,,1,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:23:20Z,2,test2
                   ,,1,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:25:00Z,2,test2
                   ,,1,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:26:40Z,2,test2
                   ,,1,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:28:20Z,2,test2
                   ,,1,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:30:00Z,2,test2
                   """

        let records = try parse_to_records(data: data)
        XCTAssertEqual(28, records.count)
        XCTAssertEqual(2, records[0].values["_value"] as? Double)
        XCTAssertEqual(2, records[6].values["_value"] as? Double)
        XCTAssertEqual(2, records[13].values["_value"] as? Double)
        XCTAssertEqual(2, records[20].values["_value"] as? Double)
        XCTAssertEqual(2, records[27].values["_value"] as? Double)
    }

    func testTableIndexNotStartAtZero() throws {
        let data = """
                   #datatype,string,long,string,string,dateTime:RFC3339,dateTime:RFC3339,dateTime:RFC3339,double,string
                   #group,false,false,true,true,true,true,false,false,true
                   #default,t1,,,,,,,,
                   ,result,table,_field,_measurement,_start,_stop,_time,_value,tag
                   ,,1,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:20:00Z,2,test1
                   ,,1,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:21:40Z,2,test1
                   ,,1,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:23:20Z,2,test1
                   ,,1,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:25:00Z,2,test1
                   ,,1,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:26:40Z,2,test1
                   ,,1,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:28:20Z,2,test1
                   ,,1,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:30:00Z,2,test1
                   ,,2,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:20:00Z,2,test2
                   ,,2,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:21:40Z,2,test2
                   ,,2,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:23:20Z,2,test2
                   ,,2,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:25:00Z,2,test2
                   ,,2,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:26:40Z,2,test2
                   ,,2,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:28:20Z,2,test2
                   ,,2,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:30:00Z,2,test2
                   """

        let records = try parse_to_records(data: data)
        XCTAssertEqual(14, records.count)
    }

    func testResponseWithError() {
        let data = """
                   #datatype,string,long,string,string,dateTime:RFC3339,dateTime:RFC3339,dateTime:RFC3339,double,string
                   #group,false,false,true,true,true,true,false,false,true
                   #default,t1,,,,,,,,
                   ,result,table,_field,_measurement,_start,_stop,_time,_value,tag
                   ,,0,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:20:00Z,2,test1
                   ,,0,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:21:40Z,2,test1
                   ,,0,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:23:20Z,2,test1
                   ,,0,value,python_client_test,2010-02-27T04:48:32.752600083Z,2020-02-27T16:48:32.752600083Z,2020-02-27T16:25:00Z,2,test1
                     
                   #datatype,string,string
                   #group,true,true
                   #default,,
                   ,error,reference
                   ,"engine: unknown field type for value: xyz",
                   """

        let expected = "(0) Reason: engine: unknown field type for value: xyz"
        XCTAssertThrowsError(try parse_to_records(data: data)) { error in
            if let error = error as? InfluxDBClient.InfluxDBError {
                XCTAssertEqual(expected, error.description)
            } else {
                XCTFail("Unexpected type of error: \(type(of: error))")
            }
        }
    }

    func testParseExportFromUserInterface() throws {
        let data = """
                   #group,false,false,true,true,true,true,true,true,false,false
                   #datatype,string,long,dateTime:RFC3339,dateTime:RFC3339,string,string,string,string,double,dateTime:RFC3339
                   #default,mean,,,,,,,,,
                   ,result,table,_start,_stop,_field,_measurement,city,location,_value,_time
                   ,,0,1754-06-26T11:30:27.613654848Z,2040-10-27T12:13:46.485Z,temperatureC,weather,London,us-midwest,30,1975-09-01T16:59:54.5Z
                   ,,1,1754-06-26T11:30:27.613654848Z,2040-10-27T12:13:46.485Z,temperatureF,weather,London,us-midwest,86,1975-09-01T16:59:54.5Z
                   """

        let tuples = try parse(data: data)
        XCTAssertEqual(2, tuples.count)
        XCTAssertEqual(false, tuples[0].table.columns[0].group)
        XCTAssertEqual(false, tuples[0].table.columns[1].group)
        XCTAssertEqual(true, tuples[0].table.columns[2].group)
    }

    func testParseInfinity() throws {
        let data = """
                   #group,false,false,true,true,true,true,true,true,true,true,false,false
                   #datatype,string,long,dateTime:RFC3339,dateTime:RFC3339,string,string,string,string,string,string,double,double
                   #default,_result,,,,,,,,,,,
                   ,result,table,_start,_stop,_field,_measurement,language,license,name,owner,le,_value
                   ,,0,2021-06-23T06:50:11.897825012Z,2021-06-25T06:50:11.897825012Z,stars,github_repository,C#,MIT License,influxdb-client-csharp,influxdata,0,0
                   ,,0,2021-06-23T06:50:11.897825012Z,2021-06-25T06:50:11.897825012Z,stars,github_repository,C#,MIT License,influxdb-client-csharp,influxdata,10,0
                   ,,0,2021-06-23T06:50:11.897825012Z,2021-06-25T06:50:11.897825012Z,stars,github_repository,C#,MIT License,influxdb-client-csharp,influxdata,20,0
                   ,,0,2021-06-23T06:50:11.897825012Z,2021-06-25T06:50:11.897825012Z,stars,github_repository,C#,MIT License,influxdb-client-csharp,influxdata,30,0
                   ,,0,2021-06-23T06:50:11.897825012Z,2021-06-25T06:50:11.897825012Z,stars,github_repository,C#,MIT License,influxdb-client-csharp,influxdata,40,0
                   ,,0,2021-06-23T06:50:11.897825012Z,2021-06-25T06:50:11.897825012Z,stars,github_repository,C#,MIT License,influxdb-client-csharp,influxdata,50,0
                   ,,0,2021-06-23T06:50:11.897825012Z,2021-06-25T06:50:11.897825012Z,stars,github_repository,C#,MIT License,influxdb-client-csharp,influxdata,60,0
                   ,,0,2021-06-23T06:50:11.897825012Z,2021-06-25T06:50:11.897825012Z,stars,github_repository,C#,MIT License,influxdb-client-csharp,influxdata,70,0
                   ,,0,2021-06-23T06:50:11.897825012Z,2021-06-25T06:50:11.897825012Z,stars,github_repository,C#,MIT License,influxdb-client-csharp,influxdata,80,0
                   ,,0,2021-06-23T06:50:11.897825012Z,2021-06-25T06:50:11.897825012Z,stars,github_repository,C#,MIT License,influxdb-client-csharp,influxdata,90,0
                   ,,0,2021-06-23T06:50:11.897825012Z,2021-06-25T06:50:11.897825012Z,stars,github_repository,C#,MIT License,influxdb-client-csharp,influxdata,+Inf,15
                   ,,0,2021-06-23T06:50:11.897825012Z,2021-06-25T06:50:11.897825012Z,stars,github_repository,C#,MIT License,influxdb-client-csharp,influxdata,-Inf,15

                   """
        let records = try parse_to_records(data: data)
        XCTAssertEqual(12, records.count)
        XCTAssertEqual(Double.infinity, records[10].values["le"] as? Double)
        XCTAssertEqual(-Double.infinity, records[11].values["le"] as? Double)
    }

    func testParseWithoutDatatype() throws {
        let data = """
                   ,result,table,_start,_stop,_field,_measurement,host,region,_value2,value1,value_str
                   ,,0,1677-09-21T00:12:43.145224192Z,2018-07-16T11:21:02.547596934Z,free,mem,A,west,121,11,test
                   ,,1,1677-09-21T00:12:43.145224192Z,2018-07-16T11:21:02.547596934Z,free,mem,A,west,121,11,test

                   """
        let records = try parse_to_records(data: data, responseMode: .onlyNames)
        XCTAssertEqual(2, records.count)
        XCTAssertEqual(11, records[0].values.count)
        XCTAssertEqual("0", records[0].values["table"] as? String)
        XCTAssertEqual("11", records[0].values["value1"] as? String)
        XCTAssertEqual("west", records[0].values["region"] as? String)
    }

    func testParseDuplicateColumnNames() throws {
        let data = """
                    #datatype,string,long,dateTime:RFC3339,dateTime:RFC3339,dateTime:RFC3339,string,string,double
                    #group,false,false,true,true,false,true,true,false
                    #default,_result,,,,,,,
                    ,result,table,_start,_stop,_time,_measurement,location,result
                    ,,0,2022-09-13T06:14:40.469404272Z,2022-09-13T06:24:40.469404272Z,2022-09-13T06:24:33.746Z,my_measurement,Prague,25.3
                    ,,0,2022-09-13T06:14:40.469404272Z,2022-09-13T06:24:40.469404272Z,2022-09-13T06:24:39.299Z,my_measurement,Prague,25.3
                    ,,0,2022-09-13T06:14:40.469404272Z,2022-09-13T06:24:40.469404272Z,2022-09-13T06:24:40.454Z,my_measurement,Prague,25.3

                   """
        let records = try parse_to_records(data: data, responseMode: .onlyNames)
        XCTAssertEqual(3, records.count)
        XCTAssertEqual(7, records[0].values.count)
        XCTAssertEqual(8, records[0].row.count)
        XCTAssertEqual(25.3, records[0].row[7] as! Double)
    }

    // swiftlint:enable line_length trailing_whitespace

    func parse_to_records(data: String, responseMode: FluxCSVParser.ResponseMode = .full)
            throws -> [QueryAPI.FluxRecord] {
        try parse(data: data, responseMode: responseMode).map {
            $0.record
        }
    }

    func parse(data: String, responseMode: FluxCSVParser.ResponseMode = .full)
            throws -> [(table: QueryAPI.FluxTable, record: QueryAPI.FluxRecord)] {
        let parser = try FluxCSVParser(data: data.data(using: .utf8)!, responseMode: responseMode)

        var records: [(table: QueryAPI.FluxTable, record: QueryAPI.FluxRecord)] = []
        while let row = try parser.next() {
            records.append(row)
        }
        return records
    }
}
