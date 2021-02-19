//
// Created by Jakub Bednář on 13/11/2020.
//

import Foundation

extension InfluxDBClient {
    /// Point defines the values that will be written to the database.
    ///
    /// - SeeAlso: http://bit.ly/influxdata-point
    public class Point {
        /// The measurement name.
        private let measurement: String
        // The measurement tags.
        private var tags: [String: String?] = [:]
        // The measurement fields.
        private var fields: [String: FieldValue?] = [:]
        /// The data point time.
        var time: Any?
        /// The data point precision.
        var precision: InfluxDBClient.TimestampPrecision

        /// Create a new Point with specified a measurement name and precision.
        ///
        /// - Parameters:
        ///   - measurement: the measurement name
        ///   - precision: the data point precision
        public init(_ measurement: String, precision: TimestampPrecision = InfluxDBClient.defaultTimestampPrecision) {
            self.measurement = measurement
            self.precision = precision
        }

        /// Adds or replaces a tag value for this point.
        ///
        /// - Parameters:
        ///   - key: the tag name
        ///   - value: the tag value
        /// - Returns: self
        @discardableResult
        public func addTag(key: String?, value: String?) -> Point {
            if let key = key {
                tags[key] = value
            }
            return self
        }

        /// Adds or replaces a field value for this point.
        ///
        /// - Parameters:
        ///   - key: the field name
        ///   - value: the field value
        /// - Returns: self
        @discardableResult
        public func addField(key: String?, value: FieldValue?) -> Point {
            if let key = key {
                fields[key] = value
            }
            return self
        }

        /// Updates the timestamp for the point.
        ///
        /// - Parameters:
        ///   - time: the timestamp. It can be `Int` or `Date`.
        ///   - precision: the timestamp precision
        /// - Returns: self
        @discardableResult
        public func time(time: Any, precision: TimestampPrecision = defaultTimestampPrecision) -> Point {
            self.precision = precision
            self.time = time
            return self
        }

        /// Creates Line Protocol from Data Point.
        ///
        /// - Parameters:
        ///   - defaultTags: default tags for Point.
        /// - Returns: Line Protocol
        public func toLineProtocol(defaultTags: [String: String?]? = nil) throws -> String? {
            let meas = escapeKey(measurement, false)
            let tags = escapeTags(defaultTags)
            let fields = try escapeFields()
            guard !fields.isEmpty else {
                return nil
            }
            let time = try escapeTime()

            return "\(meas)\(tags) \(fields)\(time)"
        }
    }

    /// Settings to store default tags.
    ///
    /// ### Example: ###
    /// ````
    /// let defaultTags = InfluxDBClient.PointSettings()
    ///         .addDefaultTag(key: "id", value: "132-987-655")
    ///         .addDefaultTag(key: "customer", value: "California Miner")
    ///         .addDefaultTag(key: "data_center", value: "${env.DATA_CENTER_LOCATION}")
    /// ````
    public class PointSettings {
        // Default tags which will be added to each point written by api.
        var tags: [String: String?] = [:]

        /// Add new default tag with key and value.
        ///
        /// - Parameters:
        ///   - key: the tag name
        ///   - value: the tag value. Could be static value or env property.
        /// - Returns: Self
        public func addDefaultTag(key: String?, value: String?) -> PointSettings {
            if let key = key {
                tags[key] = value
            }
            return self
        }

        internal func evaluate() -> [String: String?] {
            let map: [String: String?] = tags.mapValues { value in
                if let value = value, value.starts(with: "${env.") {
                    let start = value.index(value.startIndex, offsetBy: 6)
                    let end = value.index(value.endIndex, offsetBy: -1)
                    let name = String(value[start..<end])
                    return ProcessInfo.processInfo.environment[name]
                }
                return value
            }
            return map
        }
    }
}

extension InfluxDBClient.Point {
    ///  Possible value types of Field
    public enum FieldValue {
        /// Support for Int8
        init(_ value: Int8) {
            self = .int(Int(value))
        }
        /// Support for Int16
        init(_ value: Int16) {
            self = .int(Int(value))
        }
        /// Support for Int32
        init(_ value: Int32) {
            self = .int(Int(value))
        }
        /// Support for Int64
        init(_ value: Int64) {
            self = .int(Int(value))
        }
        /// Support for UInt8
        init(_ value: UInt8) {
            self = .uint(UInt(value))
        }
        /// Support for UInt16
        init(_ value: UInt16) {
            self = .uint(UInt(value))
        }
        /// Support for UInt32
        init(_ value: UInt32) {
            self = .uint(UInt(value))
        }
        /// Support for UInt64
        init(_ value: UInt64) {
            self = .uint(UInt(value))
        }
        /// Support for Float
        init(_ value: Float) {
            self = .double(Double(value))
        }

        /// signed integer number
        case int(Int)
        /// unsigned integer number
        case uint(UInt)
        /// floating number
        case double(Double)
        /// true or false value
        case boolean(Bool)
        /// string value
        case string(String)
    }
}

extension InfluxDBClient.Point {
    // swiftlint:disable large_tuple cyclomatic_complexity function_body_length

    /// Create a new Point from Tuple.
    ///
    /// - Parameters:
    ///   - tuple: the tuple with keys: `measurement`, `tags`, `fields` and `time`
    ///   - precision: the data point precision
    /// - Returns: created Point
    public class func fromTuple(
            _ tuple: (
                    measurement: String,
                    tags: [String?: String?]?,
                    fields: [String?: Any?], time: Any?),
            precision: InfluxDBClient.TimestampPrecision? = nil) -> InfluxDBClient.Point {
        let timestampPrecision = precision ?? InfluxDBClient.defaultTimestampPrecision
        let point = InfluxDBClient.Point(tuple.measurement, precision: timestampPrecision)
        if let tags = tuple.tags {
            for tag in tags {
                point.addTag(key: tag.0, value: tag.1)
            }
        }
        for field in tuple.fields {
            if let value = field.1 {
                let key = field.0
                var fieldValue: FieldValue

                switch value {
                case let intValue as Int:
                    fieldValue = .int(intValue)
                case let intValue as Int8:
                    fieldValue = FieldValue(intValue)
                case let intValue as Int16:
                    fieldValue = FieldValue(intValue)
                case let intValue as Int32:
                    fieldValue = FieldValue(intValue)
                case let intValue as Int64:
                    fieldValue = FieldValue(intValue)
                case let uintValue as UInt:
                    fieldValue = .uint(uintValue)
                case let uintValue as UInt8:
                    fieldValue = FieldValue(uintValue)
                case let uintValue as UInt16:
                    fieldValue = FieldValue(uintValue)
                case let uintValue as UInt32:
                    fieldValue = FieldValue(uintValue)
                case let uintValue as UInt64:
                    fieldValue = FieldValue(uintValue)
                case let floatValue as Float:
                    fieldValue = FieldValue(floatValue)
                case let doubleValue as Double:
                    fieldValue = .double(doubleValue)
                case let boolValue as Bool:
                    fieldValue = .boolean(boolValue)
                default:
                    fieldValue = .string(String(describing: value))
                }
                point.addField(key: key, value: fieldValue)
            }
        }
        if let time = tuple.time {
            point.time(time: time, precision: timestampPrecision)
        }
        return point
    }
    // swiftlint:enable large_tuple cyclomatic_complexity function_body_length
}

extension InfluxDBClient.Point: CustomStringConvertible {
    /// Line Protocol from Data Point.
    public var description: String {
        "Point: measurement:\(measurement), tags:\(tags), fields:\(fields), time:\(time ?? "nil")"
    }
}

extension InfluxDBClient.Point {
    private func escapeKey(_ key: String, _ escapeEqual: Bool = true) -> String {
        key.reduce(into: "") { result, character in
            switch character {
            case "\n":
                result.append("\\n")
            case "\r":
                result.append("\\r")
            case "\t":
                result.append("\\t")
            case ",", " ":
                result.append("\\\(character)")
            case "=":
                if escapeEqual {
                    result.append("\\")
                }
                result.append(character)
            default:
                result.append(character)
            }
        }
    }

    private func escapeTags(_ defaultTags: [String: String?]?) -> String {
        tags
                .merging(defaultTags ?? [:]) { current, _ in
                    current
                }
                .sorted {
                    $0.key < $1.key
                }.reduce(into: "") { result, keyValue in
                    guard !keyValue.key.isEmpty else {
                        return
                    }
                    if let value = keyValue.value, !value.isEmpty {
                        result.append(",")
                        result.append(escapeKey(keyValue.key))
                        result.append("=")
                        result.append(escapeKey(value))
                    }
                }
    }

    private func escapeFields() throws -> String {
        var mappedFields = try fields.sorted {
            $0.key < $1.key
        }.reduce(into: "") { result, keyValue in
            if keyValue.key.isEmpty {
                return
            }
            guard let value = keyValue.value else {
                return
            }
            if let escaped = try escapeValue(value) {
                // key
                result.append(escapeKey(keyValue.key))
                // key=
                result.append("=")
                // key=value
                result.append(escaped)
                // key=value,
                result.append(",")
            }
        }

        if !mappedFields.isEmpty {
            _ = mappedFields.removeLast()
        }
        return mappedFields
    }

    private func escapeValue(_ value: FieldValue) throws -> String? {
        switch value {
        case .int(let value):
            return "\(value)i"
        case .uint(let value):
            return "\(value)u"
        case .double(let value):
            if value.isInfinite || value.isNaN {
                return nil
            }
            return "\(value)"
        case .boolean(let value):
            return "\(value ? "true" : "false")"
        case .string(let value):
            let escaped = value.reduce(into: "") { result, character in
                switch character {
                case "\\", "\"":
                    result.append("\\")
                    result.append(character)
                default:
                    result.append(character)
                }
            }
            return "\"\(escaped)\""
        }
    }

    private func escapeTime() throws -> String {
        guard let time = time else {
            return ""
        }

        switch time {
        case is Int:
            return " \(time)"
        case let date as Date:
            let since1970 = date.timeIntervalSince1970
            switch precision {
            case .s:
                return " \(UInt64(since1970))"
            case .ms:
                return " \(UInt64(since1970 * 1_000))"
            case .us:
                return " \(UInt64(since1970 * 1_000_000))"
            default:
                return " \(UInt64(since1970 * 1_000_000_000))"
            }
        default:
            throw InfluxDBClient.InfluxDBError
                    .generic("Time value is not supported: \(time) with type: \(type(of: time))")
        }
    }
}
