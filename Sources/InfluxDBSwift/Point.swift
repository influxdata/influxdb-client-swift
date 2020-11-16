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

        /// Adds or replaces a tag value for this point.
        ///
        /// - Parameters:
        ///   - key: the tag name
        ///   - value: the tag value
        /// - Returns: self
        public func addTag(key: String?, value: String?) -> Point {
            if let key = key {
                self.tags[key] = value
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
                self.fields[key] = value
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
        /// - Returns: Line Protocol
        public func toLineProtocol() throws -> String? {
            let meas = escapeKey(measurement, false)
            let tags = escapeTags()
            let fields = try escapeFields()
            guard !fields.isEmpty else {
                return nil
            }
            let time = try escapeTime()

            return "\(meas)\(tags) \(fields)\(time)"
        }

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

        private func escapeTags() -> String {
            tags.sorted {
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
            case is Int:
                return "\(value)i"
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
                throw InfluxDBError.generic("Field value is not supported: \(value) with type: \(type(of: value))")
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
                var utcCalendar = Calendar.current
                if let utcTimeZone = TimeZone(abbreviation: "UTC") {
                    utcCalendar.timeZone = utcTimeZone
                }

                let components: DateComponents = utcCalendar.dateComponents(in: utcCalendar.timeZone, from: date)

                guard let since1970 = utcCalendar.date(from: components)?.timeIntervalSince1970 else {
                    throw InfluxDBError.generic("Time cannot be converted to nanoseconds: \(time)")
                }

                let nanoseconds = Int64((since1970) * 1000000000)
                switch precision {
                case WritePrecision.s:
                    return " \(nanoseconds / 1000000000)"
                case WritePrecision.ms:
                    return " \(nanoseconds / 1000000)"
                case WritePrecision.us:
                    return " \(nanoseconds / 1000)"
                default:
                    return " \(nanoseconds)"
                }
            default:
                throw InfluxDBError.generic("Time value is not supported: \(time) with type: \(type(of: time))")
            }
        }
    }
}
