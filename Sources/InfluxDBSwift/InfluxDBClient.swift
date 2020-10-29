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
    internal let url: String
    /// Authentication token.
    internal let token: String
    /// The options to configre client.
    internal let options: InfluxDBOptions
    /// Shared URLSession across the client.
    internal let session: URLSession

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
        self.url = url
        self.token = token
        self.options = options ?? InfluxDBClient.InfluxDBOptions()

        var headers: [AnyHashable: Any] = [:]
        headers["Authorization"] = "Token \(token)"
        headers["User-Agent"] = "influxdb-client-swift/\(Self.version)"

        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = headers
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
    public convenience init(url: String, username: String, password: String, database: String, retention_policy: String,
                            precision: WritePrecision = WritePrecision.ns, protocolClasses: [AnyClass]? = nil) {

        let options: InfluxDBOptions = InfluxDBOptions(bucket: "\(database)/\(retention_policy)", precision: precision)

        self.init(url: url, token: "\(username):\(password)", options: options, protocolClasses: protocolClasses)

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
        public var bucket: String?
        /// Default destination bucket for writes.
        /// - SeeAlso: https://docs.influxdata.com/influxdb/v2.0/organizations/view-orgs/
        public var org: String?
        /// Default precision for the unix timestamps within the body line-protocol.
        /// - SeeAlso: https://docs.influxdata.com/influxdb/v2.0/reference/glossary/#precision
        public var precision = WritePrecision.ns
    }
}

// swiftlint:disable identifier_name
extension InfluxDBClient {
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
