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
        var time: TimestampValue?

        /// Create a new Point with specified a measurement name and precision.
        ///
        /// - Parameters:
        ///   - measurement: the measurement name
        ///   - precision: the data point precision
        public init(_ measurement: String) {
            self.measurement = measurement
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
        /// - Returns: self
        @discardableResult
        public func time(time: TimestampValue) -> Point {
            self.time = time
            return self
        }

        /// Creates Line Protocol from Data Point.
        ///
        /// - Parameters:
        ///   - precision: the precision to use for the generated line protocol
        ///   - defaultTags: default tags for Point.
        /// - Returns: Line Protocol
        public func toLineProtocol(precision: TimestampPrecision = defaultTimestampPrecision,
                                   defaultTags: [String: String?]? = nil) throws -> String? {
            let meas = escapeKey(measurement, false)
            let tags = escapeTags(defaultTags)
            let fields = try escapeFields()
            guard !fields.isEmpty else {
                return nil
            }
            let time = escapeTime(precision)

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
    public struct PointSettings {
        // Default tags which will be added to each point written by api.
        var tags: [String: String?] = [:]

        /// Create a new PointSettings.
        public init() {}

        /// Add new default tag with key and value.
        ///
        /// - Parameters:
        ///   - key: the tag name
        ///   - value: the tag value. Could be static value or env property.
        /// - Returns: Self
        public func addDefaultTag(key: String?, value: String?) -> PointSettings {
            if let key = key {
                var result = self
                result.tags[key] = value
                return result
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
    /// Possible value types of Field
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

    /// Possible value types of Field
    public enum TimestampValue: CustomStringConvertible {
        // The number of ticks since the UNIX epoch. The value has to be specified with correct precision.
        case interval(Int, InfluxDBClient.TimestampPrecision = InfluxDBClient.defaultTimestampPrecision)
        // The date timestamp.
        case date(Date)

        public var description: String {
            switch self {
            case let .interval(ticks, precision):
                return "\(ticks) [\(precision)]"
            case let .date(date):
                return "\(date)"
            }
        }
    }
}

extension InfluxDBClient.Point {
    /// Tuple definition for construct `Point`.
    public typealias Tuple = (measurement: String,
                              tags: [String?: String?]?,
                              fields: [String?: InfluxDBClient.Point.FieldValue?],
                              time: InfluxDBClient.Point.TimestampValue?)
    /// Create a new Point from Tuple.
    ///
    /// - Parameters:
    ///   - tuple: the tuple with keys: `measurement`, `tags`, `fields` and `time`
    ///   - precision: the data point precision
    /// - Returns: created Point
    public class func fromTuple(_ tuple: Tuple) -> InfluxDBClient.Point {
        let point = InfluxDBClient.Point(tuple.measurement)
        if let tags = tuple.tags {
            for tag in tags {
                point.addTag(key: tag.0, value: tag.1)
            }
        }
        for field in tuple.fields {
            point.addField(key: field.0, value: field.1)
        }
        if let time = tuple.time {
            point.time(time: time)
        }
        return point
    }
}

extension InfluxDBClient.Point: CustomStringConvertible {
    /// Line Protocol from Data Point.
    public var description: String {
        "Point: measurement:\(measurement), tags:\(tags), fields:\(fields), time:\(time?.description ?? "nil")"
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

    private func escapeTime(_ out: InfluxDBClient.TimestampPrecision) -> String {
        guard let time = time else {
            return ""
        }

        let sinceEpoch: UInt64
        switch time {
        case let .interval(ticks, precision):
            var multiplier: Decimal
            switch precision {
            case .s:
                multiplier = 1_000_000_000
            case .ms:
                multiplier = 1_000_000
            case .us:
                multiplier = 1_000
            case .ns:
                multiplier = 1
            }
            switch out {
            case .s:
                multiplier /= 1_000_000_000
            case .ms:
                multiplier /= 1_000_000
            case .us:
                multiplier /= 1_000
            case .ns:
                multiplier /= 1
            }

            let decimal = Decimal(ticks) * multiplier
            sinceEpoch = (decimal as NSDecimalNumber).uint64Value
        case let .date(date):
            let multiplier: Double
            switch out {
            case .s:
                multiplier = 1
            case .ms:
                multiplier = 1_000
            case .us:
                multiplier = 1_000_000
            default:
                multiplier = 1_000_000_000
            }
            sinceEpoch = UInt64(date.timeIntervalSince1970 * multiplier)
        }

        return " \(sinceEpoch)"
    }
}
