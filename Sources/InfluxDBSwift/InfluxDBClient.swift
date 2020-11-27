//
// Created by Jakub Bednář on 20/10/2020.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// A InfluxDB Client providing a support for APIs to write and query data.
public class InfluxDBClient {
    /// Version of client.
    public static var version: String = "0.0.1"
    /// InfluxDB host and port.
    public let url: String
    /// Authentication token.
    internal let token: String
    /// The options to configre client.
    internal let options: InfluxDBOptions
    /// Shared URLSession across the client.
    public let session: URLSession

    /// Create a new client for a InfluxDB.
    ///
    /// - Parameters:
    ///   - url: InfluxDB host and port.
    ///   - token: Authentication token.
    ///   - options: optional `InfluxDBOptions` to use for this client.
    ///   - protocolClasses: optional array of extra protocol subclasses that handle requests.
    ///
    /// - SeeAlso: https://docs.influxdata.com/influxdb/v2.0/reference/urls/#influxdb-oss-urls
    /// - SeeAlso: https://docs.influxdata.com/influxdb/v2.0/security/tokens/
    public init(url: String, token: String, options: InfluxDBOptions? = nil, protocolClasses: [AnyClass]? = nil) {
        self.url = url.hasSuffix("/") ? String(url.dropLast(1)) : url
        self.token = token
        self.options = options ?? InfluxDBClient.InfluxDBOptions()

        var headers: [AnyHashable: Any] = [:]
        headers["Authorization"] = "Token \(token)"
        headers["User-Agent"] = "influxdb-client-swift/\(Self.version)"

        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = headers
        configuration.timeoutIntervalForRequest = self.options.timeoutIntervalForRequest
        configuration.timeoutIntervalForResource = self.options.timeoutIntervalForResource
        configuration.protocolClasses = protocolClasses

        self.session = URLSession(configuration: configuration)
    }

    /// Create a new client for InfluxDB 1.8 compatibility API.
    ///
    /// - Parameters:
    ///   - url: InfluxDB host and port.
    ///   - username: Username for authentication.
    ///   - password: Password for authentication.
    ///   - database: Target database.
    ///   - retention_policy: Target retention policy.
    ///   - precision: Default precision for the unix timestamps within the body line-protocol.
    ///   - protocolClasses: optional array of extra protocol subclasses that handle requests.
    ///
    /// - SeeAlso: https://docs.influxdata.com/influxdb/v1.8/tools/api/#influxdb-2-0-api-compatibility-endpoints
    public convenience init(url: String,
                            username: String,
                            password: String,
                            database: String,
                            retentionPolicy: String,
                            precision: WritePrecision = WritePrecision.ns,
                            protocolClasses: [AnyClass]? = nil) {
        let options = InfluxDBOptions(bucket: "\(database)/\(retentionPolicy)", precision: precision)

        self.init(url: url, token: "\(username):\(password)", options: options, protocolClasses: protocolClasses)
    }

    /// Creates WriteApi with supplied default settings.
    ///
    /// - Returns: WriteAPI instance
    public func getWriteAPI() -> WriteAPI {
        WriteAPI(client: self)
    }

    /// Creates QueryAPI with supplied default settings.
    ///
    /// - Returns: QueryAPI instance
    public func getQueryAPI() -> QueryAPI {
        QueryAPI(client: self)
    }

    /// Release all allocated resources.
    public func close() {
        session.invalidateAndCancel()
    }
}

extension InfluxDBClient {
    /// Options to use when creating a `InfluxDBClient`.
    public struct InfluxDBOptions {
        /// Default organization bucket for writes.
        /// - SeeAlso: https://docs.influxdata.com/influxdb/v2.0/organizations/buckets/view-buckets/
        public let bucket: String?
        /// Default destination bucket for writes.
        /// - SeeAlso: https://docs.influxdata.com/influxdb/v2.0/organizations/view-orgs/
        public let org: String?
        /// Default precision for the unix timestamps within the body line-protocol.
        /// - SeeAlso: https://docs.influxdata.com/influxdb/v2.0/reference/glossary/#precision
        public let precision: InfluxDBClient.WritePrecision
        /// The timeout interval to use when waiting for additional data. Default to 60 sec.
        /// - SeeAlso: http://bit.ly/timeoutIntervalForRequest
        public let timeoutIntervalForRequest: TimeInterval
        /// The maximum amount of time that a resource request should be allowed to take. Default to 5 min.
        /// - SeeAlso: http://bit.ly/timeoutIntervalForResource
        public let timeoutIntervalForResource: TimeInterval
        /// Enable Gzip compression for HTTP requests.
        /// Currently only the `Write` and `Query` endpoints supports the Gzip compression.
        /// - SeeAlso: https://docs.influxdata.com/influxdb/v2.0/api/#operation/PostWrite
        /// - SeeAlso: https://docs.influxdata.com/influxdb/v2.0/api/#operation/PostQuery
        public let enableGzip: Bool

        /// Create a new options for client.
        ///
        /// - Parameters:
        ///   - bucket: Default destination bucket for writes.
        ///   - org: Default organization bucket for writes.
        ///   - precision: Default precision for the unix timestamps within the body line-protocol.
        ///   - timeoutIntervalForRequest: Timeout interval to use when waiting for additional data.
        ///   - timeoutIntervalForResource: Maximum amount of time that a resource request should be allowed to take.
        ///   - enableGzip: Enable Gzip compression for HTTP requests.
        public init(bucket: String? = nil,
                    org: String? = nil,
                    precision: WritePrecision = defaultWritePrecision,
                    timeoutIntervalForRequest: TimeInterval = 60,
                    timeoutIntervalForResource: TimeInterval = 60 * 5,
                    enableGzip: Bool = false) {
            self.bucket = bucket
            self.org = org
            self.precision = precision
            self.timeoutIntervalForRequest = timeoutIntervalForRequest
            self.timeoutIntervalForResource = timeoutIntervalForResource
            self.enableGzip = enableGzip
        }
    }
}

extension InfluxDBClient {
    /// The general InfluxDB error.
    public enum InfluxDBError: Error, CustomStringConvertible {
        /// Error response to HTTP request.
        ///
        /// - errorCode: HTTP status code
        /// - headers: Response HTTP headers
        /// - body: Response body
        /// - cause: Cause of error
        case error(_ statusCode: Int, _ headers: [AnyHashable: Any]?, _ body: [String: Any]?, _ cause: Error)

        /// Generic error.
        ///
        /// - message: Reason
        case generic(_ message: String)

        public var description: String {
            switch self {
            case let .error(statusCode, headers, body, cause):
                var desc = "(\(statusCode)) Reason: \(cause)"
                if let body = body {
                    desc.append(", HTTP Body: \(body)")
                }
                if let headers = headers {
                    desc.append(", HTTP Headers: \(headers.reduce(into: [:]) { $0["\($1.0)"] = "\($1.1)" })")
                }
                return desc
            case let .generic(message):
                return message
            }
        }
    }
}

// swiftlint:disable identifier_name
extension InfluxDBClient {
    /// Default Write Precision is Nanoseconds.
    public static let defaultWritePrecision = WritePrecision.ns

    /// An enum represents the precision for the unix timestamps within the body line-protocol.
    /// - SeeAlso: https://docs.influxdata.com/influxdb/v2.0/write-data/#timestamp-precision
    public enum WritePrecision: String, Codable, CaseIterable {
        /// Milliseconds
        case ms
        /// Seconds
        case s
        /// Microseconds
        case us
        /// Nanoseconds
        case ns
    }
}

// swiftlint:enable identifier_name
