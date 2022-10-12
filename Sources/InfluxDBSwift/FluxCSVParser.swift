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
    private let responseMode: FluxCSVParser.ResponseMode
    private var table: QueryAPI.FluxTable?
    private var startNewTable = false
    private var groups: [String] = []

    init(data: Data, responseMode: FluxCSVParser.ResponseMode = .full) throws {
        csv = try CSVReader(stream: InputStream(data: data))
        self.responseMode = responseMode
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
            if (Self.annotations.contains(token) && !startNewTable) || (responseMode == .onlyNames && table == nil) {
                table = QueryAPI.FluxTable()
                groups = []
                startNewTable = true
            } else if table == nil {
                throw InfluxDBClient.InfluxDBError.generic(Self.errorMessage)
            }

            switch token {
            case Self.annotationDatatype:
                try addDatatype(row: row)
            case Self.annotationGroup:
                groups = row
            case Self.annotationDefault:
                try addDefault(row: row[1..<row.count])
            default:
                if startNewTable {
                    if responseMode == .onlyNames && table?.columns.isEmpty ?? true {
                        groups = row.map { _ in
                            "false"
                        }
                        try addDatatype(row: row.map { _ in
                            "string"
                        })
                    }
                    try addGroups()
                    try addNames(row: row)
                    startNewTable = false
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

    private func addDatatype(row: [String]) throws {
        guard let table = table else {
            throw InfluxDBClient.InfluxDBError.generic(Self.errorMessage)
        }

        row[1..<row.count].enumerated().forEach {
            let column = QueryAPI.FluxColumn(index: $0.offset, dataType: $0.element)
            table.columns.append(column)
        }
    }

    private func addGroups() throws {
        guard let table = table else {
            throw InfluxDBClient.InfluxDBError.generic(Self.errorMessage)
        }

        groups[1..<groups.count].enumerated().forEach {
            let column: QueryAPI.FluxColumn = table.columns[$0.offset]
            column.group = ($0.element as NSString).boolValue
        }
    }

    private func addNames(row: [String]) throws {
        guard let table = table else {
            throw InfluxDBClient.InfluxDBError.generic(Self.errorMessage)
        }

        row[1..<row.count].enumerated().forEach {
            let column: QueryAPI.FluxColumn = table.columns[$0.offset]
            column.name = $0.element
        }

        let duplicates = Dictionary(grouping: table.columns.compactMap { val in
            val.name
        }, by: { $0 })
                .filter {
                    $1.count > 1
                }
                .keys
        if duplicates.count > 0 {
            print("""
                  The response contains columns with duplicated names: \(duplicates.joined(separator: ", "))
                  You should use the 'FluxRecord.row' to access your data instead of 'FluxRecord.values' dictionary.
                  """)
        }
    }

    private func parseRow(row: [String]) throws -> QueryAPI.FluxRecord {
        guard let table = table else {
            throw InfluxDBClient.InfluxDBError.generic(Self.errorMessage)
        }
        var recordRow: [Any] = Array()
        let values: [String: Decodable] = table.columns.reduce(into: [String: Decodable]()) { result, column in
            var value: String = row[column.index + 1]
            if value.isEmpty {
                value = column.defaultValue
            }
            switch column.dataType {
            case "boolean":
                let strVal = (value as NSString).boolValue
                result[column.name] = strVal
                recordRow.append(strVal as Any)
                break
            case "unsignedLong":
                let strVal = UInt64(value)
                result[column.name] = strVal
                recordRow.append(strVal! as Any)
                break
            case "long":
                let strVal = Int64(value)
                result[column.name] = strVal
                recordRow.append(strVal! as Any)
                break
            case "double":
                let strVal = Double(value)
                result[column.name] = strVal
                recordRow.append(strVal! as Any)
                break
            case "string":
                result[column.name] = value
                recordRow.append(value)
                break
            case "dateTime:RFC3339", "dateTime:RFC3339Nano":
                let strVal = CodableHelper.dateFormatter.date(from: value)
                result[column.name] = strVal
                recordRow.append(strVal! as Any)
                break
            case "base64Binary":
                let strVal = Data(base64Encoded: value)
                result[column.name] = strVal
                recordRow.append(strVal! as Any)
                break
            case "duration":
                let strVal = Int64(value)
                result[column.name] = strVal
                recordRow.append(strVal! as Any)
                break
            default:
                result[column.name] = value
                recordRow.append(value as Any)
            }
        }

        return QueryAPI.FluxRecord(values: values, row: recordRow)
    }
}

extension FluxCSVParser {
    private enum ParsingState {
        case normal
        case error
    }

    /// The configuration for expected amount of metadata response from InfluxDB.
    enum ResponseMode {
        /// full information about types, default values and groups
        case full
        /// useful for Invokable scripts
        case onlyNames
    }
}
