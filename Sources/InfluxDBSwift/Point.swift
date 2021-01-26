//
// Created by Jakub Bednář on 13/11/2020.
//

import Foundation

extension InfluxDBClient {
    /// Point defines the values that will be written to the database.
    ///
    /// - SeeAlso: http://bit.ly/influxdata-point
    public class Point: NSObject {
        /// The measurement name.
        private let measurement: String
        // The measurement tags.
        private var tags: [String: String?] = [:]
        // The measurement fields.
        private var fields: [String: Any?] = [:]
        /// The data point time.
        internal var time: Any?
        /// The data point precision.
        internal var precision: InfluxDBClient.WritePrecision

        /// Create a new Point with specified a measurement name and precision.
        ///
        /// - Parameters:
        ///   - measurement: the measurement name
        ///   - precision: the data point precision
        public init(_ measurement: String, precision: WritePrecision = InfluxDBClient.defaultWritePrecision) {
            self.measurement = measurement
            self.precision = precision
        }

        // swiftlint:disable large_tuple

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
                precision: WritePrecision? = nil) -> Point {
            let point = InfluxDBClient.Point(tuple.measurement, precision: precision ?? defaultWritePrecision)
            if let tags = tuple.tags {
                for tag in tags {
                    _ = point.addTag(key: tag.0, value: tag.1)
                }
            }
            for field in tuple.fields {
                _ = point.addField(key: field.0, value: field.1)
            }
            if let time = tuple.time {
                _ = point.time(time: time, precision: precision ?? defaultWritePrecision)
            }
            return point
        }

        // swiftlint:enable large_tuple

        /// Adds or replaces a tag value for this point.
        ///
        /// - Parameters:
        ///   - key: the tag name
        ///   - value: the tag value
        /// - Returns: self
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
        ///   - value: the field value. It can be `Int`, `Float`, `Double`, `Bool` or `String`
        /// - Returns: self
        public func addField(key: String?, value: Any?) -> Point {
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
        public func time(time: Any, precision: WritePrecision = defaultWritePrecision) -> Point {
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

        /// Line Protocol from Data Point.
        override public var description: String {
            "Point: measurement:\(measurement), tags:\(tags), fields:\(fields), time:\(time ?? "nil")"
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
        internal var tags: [String: String?] = [:]

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

    private func escapeValue(_ value: Any) throws -> String? {
        switch value {
        case is Int, is Int8, is Int16, is Int32, is Int64:
            return "\(value)i"
        case is UInt, is UInt8, is UInt16, is UInt32, is UInt64:
            return "\(value)u"
        case let floatValue as Float:
            if floatValue.isInfinite || floatValue.isNaN {
                return nil
            }
            return "\(value)"
        case let doubleValue as Double:
            if doubleValue.isInfinite || doubleValue.isNaN {
                return nil
            }
            return "\(value)"
        case let boolValue as Bool:
            return "\(boolValue ? "true" : "false")"
        case let stringValue as String:
            let escaped = stringValue.reduce(into: "") { result, character in
                switch character {
                case "\\", "\"":
                    result.append("\\")
                    result.append(character)
                default:
                    result.append(character)
                }
            }
            return "\"\(escaped)\""
        default:
            throw InfluxDBClient.InfluxDBError
                    .generic("Field value is not supported: \(value) with type: \(type(of: value))")
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
            case InfluxDBClient.WritePrecision.s:
                return " \(UInt64(since1970))"
            case InfluxDBClient.WritePrecision.ms:
                return " \(UInt64(since1970 * 1_000))"
            case InfluxDBClient.WritePrecision.us:
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
