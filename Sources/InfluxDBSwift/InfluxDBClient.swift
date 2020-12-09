//
// Created by Jakub Bednář on 20/10/2020.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// A InfluxDB Client providing a support for APIs to write and query data.
///
/// ### Example: ###
/// ````
/// let options: InfluxDBClient.InfluxDBOptions = InfluxDBClient.InfluxDBOptions(
///        bucket: "my-bucket",
///        org: "my-org",
///        precision: InfluxDBClient.WritePrecision.ns)
///
/// let client = InfluxDBClient(url: "http://localhost:8086", token: "my-token", options: options)
///
/// ...
///
/// client.close()
/// ````
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

        session = URLSession(configuration: configuration)
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

        /// Wrapped generic error into InfluxDBError.
        ///
        /// - cause: Cause of error
        case cause(_ cause: Error)

        /// The error that occurs during execution Flux query.
        ///
        /// - reference: Reference code
        /// - message: Reason
        case queryException(_ reference: Int, _ message: String)

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
            case let .queryException(reference, message):
                return "(\(reference)) Reason: \(message)"
            case let .cause(cause):
                return "Reason: \(cause)"
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

extension InfluxDBClient {
    internal enum GZIPMode: String, Codable, CaseIterable {
        /// Request could be encoded by GZIP.
        case request
        /// Response could be encoded by GZIP.
        case response
    }
    // swiftlint:disable function_body_length function_parameter_count
    internal func httpPost(_ urlComponents: URLComponents?,
                           _ contentTypeHeader: String,
                           _ acceptHeader: String,
                           _ gzipMode: InfluxDBClient.GZIPMode,
                           _ content: Data,
                           _ responseQueue: DispatchQueue,
                           _ completion: @escaping (
                                   _ result: Swift.Result<Data?, InfluxDBClient.InfluxDBError>) -> Void) {
        do {
            guard let url = urlComponents?.url else {
                throw InfluxDBClient.InfluxDBError.error(
                        -1,
                        nil,
                        nil,
                        InfluxDBClient.InfluxDBError.generic("Invalid URL"))
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"

            // Body
            var body: Data! = content
            if options.enableGzip && InfluxDBClient.GZIPMode.request == gzipMode {
                body = try content.gzipped()
            }
            request.httpBody = body

            // Headers
            request.setValue(contentTypeHeader, forHTTPHeaderField: "Content-Type")
            request.setValue(String(body.count), forHTTPHeaderField: "Content-Length")
            request.setValue(acceptHeader, forHTTPHeaderField: "Accept")
            request.setValue("identity", forHTTPHeaderField: "Accept-Encoding")
            request.setValue(
                    options.enableGzip && InfluxDBClient.GZIPMode.request == gzipMode ? "gzip" : "identity",
                    forHTTPHeaderField: "Content-Encoding")

            session.configuration.httpAdditionalHeaders?.forEach { key, value in
                request.setValue("\(value)", forHTTPHeaderField: "\(key)")
            }

            let task = session.dataTask(with: request) { data, response, error in
                responseQueue.async {
                    if let error = error {
                        completion(.failure(InfluxDBClient.InfluxDBError.error(
                                -1,
                                nil,
                                CodableHelper.toErrorBody(data),
                                error)))
                        return
                    }

                    guard let httpResponse = response as? HTTPURLResponse else {
                        completion(.failure(InfluxDBClient.InfluxDBError.error(
                                -2,
                                nil,
                                CodableHelper.toErrorBody(data),
                                InfluxDBClient.InfluxDBError.generic("Missing data"))))
                        return
                    }

                    guard Array(200..<300).contains(httpResponse.statusCode) else {
                        completion(.failure(InfluxDBClient.InfluxDBError.error(
                                httpResponse.statusCode,
                                httpResponse.allHeaderFields,
                                CodableHelper.toErrorBody(data),
                                InfluxDBClient.InfluxDBError.generic("Unsuccessful HTTP StatusCode"))))
                        return
                    }

                    completion(.success(data))
                }
            }

            task.resume()
        } catch {
            responseQueue.async {
                completion(.failure(InfluxDBClient.InfluxDBError.error(415, nil, nil, error)))
            }
        }
    }
    // swiftlint:enable function_body_length function_parameter_count
}
