//
// Created by Jakub Bednář on 30/11/2020.
//

import CSV
import Foundation

internal class FluxCSVParser {
    private static let errorMessage = "Unable to parse CSV response. FluxTable definition was not found."
    private static let annotationDatatype = "#datatype"
    private static let annotationGroup = "#group"
    private static let annotationDefault = "#default"
    private static let annotations = [annotationDatatype, annotationGroup, annotationDefault]

    private let csv: CSVReader
    private var state = FluxCSVParser.ParsingState.normal
    private var table: QueryAPI.FluxTable?
    private var startNewTable = true
    private var groups: ArraySlice<String> = []

    internal init(data: Data) throws {
        csv = try CSVReader(stream: InputStream(data: data))
    }

    internal func next() throws -> (table: QueryAPI.FluxTable, record: QueryAPI.FluxRecord)? {
        while let row = csv.next() {
            if row.count <= 1 {
                continue
            }
            //
            // Response has HTTP status ok, but response is error.
            //
            if row.count >= 3 && row[1] == "error" && row[2] == "reference" {
                state = FluxCSVParser.ParsingState.error
                continue
            }
            //
            // Throw InfluxException with error response
            //
            if FluxCSVParser.ParsingState.error == state {
                throw InfluxDBClient.InfluxDBError.queryException(Int(row[2]) ?? 0, row[1])
            }

            let token = row[0]
            if Self.annotations.contains(token) && startNewTable {
                table = QueryAPI.FluxTable()
                groups = []
                startNewTable = false
            } else if table == nil {
                throw InfluxDBClient.InfluxDBError.generic(Self.errorMessage)
            }

            switch token {
            case Self.annotationDatatype:
                try addDatatype(row: row[1..<row.count])
            case Self.annotationGroup:
                groups = row[1..<row.count]
            case Self.annotationDefault:
                try addDefault(row: row[1..<row.count])
            default:
                if !startNewTable {
                    startNewTable = true
                    try addGroups()
                    try addNames(row: row[1..<row.count])
                    continue
                }

                if let table = table {
                    let record = try parseRow(row: row)
                    return (table: table, record: record)
                }
            }
        }

        return nil
    }

    private func addDefault(row: ArraySlice<String>) throws {
        guard let table = table else {
            throw InfluxDBClient.InfluxDBError.generic(Self.errorMessage)
        }

        row.enumerated().forEach {
            let column: QueryAPI.FluxColumn = table.columns[$0.offset]
            column.defaultValue = $0.element
        }
    }

    private func addDatatype(row: ArraySlice<String>) throws {
        guard let table = table else {
            throw InfluxDBClient.InfluxDBError.generic(Self.errorMessage)
        }

        row.enumerated().forEach {
            let column = QueryAPI.FluxColumn(index: $0.offset, dataType: $0.element)
            table.columns.append(column)
        }
    }

    private func addGroups() throws {
        guard let table = table else {
            throw InfluxDBClient.InfluxDBError.generic(Self.errorMessage)
        }

        groups.enumerated().forEach {
            let column: QueryAPI.FluxColumn = table.columns[$0.offset]
            column.group = ($0.element as NSString).boolValue
        }
    }

    private func addNames(row: ArraySlice<String>) throws {
        guard let table = table else {
            throw InfluxDBClient.InfluxDBError.generic(Self.errorMessage)
        }

        row.enumerated().forEach {
            let column: QueryAPI.FluxColumn = table.columns[$0.offset]
            column.name = $0.element
        }
    }

    private func parseRow(row: [String]) throws -> QueryAPI.FluxRecord {
        guard let table = table else {
            throw InfluxDBClient.InfluxDBError.generic(Self.errorMessage)
        }

        let values: [String: Decodable] = table.columns.reduce(into: [String: Decodable]()) { result, column in
            var value: String = row[column.index + 1]
            if value.isEmpty {
                value = column.defaultValue
            }
            switch column.dataType {
            case "boolean":
                result[column.name] = (value as NSString).boolValue
            case "unsignedLong":
                result[column.name] = UInt64(value)
            case "long":
                result[column.name] = Int64(value)
            case "double":
                result[column.name] = Double(value)
            case "string":
                result[column.name] = value
            case "dateTime:RFC3339", "dateTime:RFC3339Nano":
                result[column.name] = CodableHelper.dateFormatter.date(from: value)
            case "base64Binary":
                result[column.name] = Data(base64Encoded: value)
            case "duration":
                result[column.name] = Int64(value)
            default:
                result[column.name] = value
            }
        }

        return QueryAPI.FluxRecord(values: values)
    }
}

extension FluxCSVParser {
    private enum ParsingState {
        case normal
        case error
    }
}
