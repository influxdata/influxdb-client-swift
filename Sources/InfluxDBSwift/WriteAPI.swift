//
// Created by Jakub Bednář on 05/11/2020.
//

#if canImport(Combine)
import Combine
#endif
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Gzip

/// The asynchronous API to Write time-series data into InfluxDB 2.0.
public class WriteAPI {
    /// Shared client.
    private let client: InfluxDBClient

    /// Create a new WriteAPI for a InfluxDB.as
    ///
    /// - Parameters
    ///   - client: Client with shared configuration and http library.
    public init(client: InfluxDBClient) {
        self.client = client
    }

    /// Write a line of Line Protocol.
    ///
    /// - Parameters:
    ///   - bucket:  The destination bucket for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - org: The destination organization for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - precision: The precision for the unix timestamps within the body line-protocol.
    ///   - record: The line of InfluxDB Line Protocol.
    ///   - responseQueue: The queue on which api response is dispatched.
    ///   - completion: completion handler to receive the data and the error objects
    ///
    /// - SeeAlso: https://docs.influxdata.com/influxdb/v2.0/reference/syntax/line-protocol/
    public func writeRecord(bucket: String? = nil,
                            org: String? = nil,
                            precision: InfluxDBClient.WritePrecision = InfluxDBClient.defaultWritePrecision,
                            record: String,
                            responseQueue: DispatchQueue = .main,
                            completion: @escaping (_ response: Void?,
                                                   _ error: InfluxDBClient.InfluxDBError?) -> Void) {
        self.writeRecords(
                bucket: bucket,
                org: org,
                precision: precision,
                records: [record],
                responseQueue: responseQueue,
                completion: completion)
    }

    /// Write lines of Line Protocol.
    ///
    /// - Parameters:
    ///   - bucket:  The destination bucket for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - org: The destination organization for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - precision: The precision for the unix timestamps within the body line-protocol.
    ///   - records: The lines in InfluxDB Line Protocol.
    ///   - responseQueue: The queue on which api response is dispatched.
    ///   - completion handler to receive the data and the error objects
    ///
    /// - SeeAlso: https://docs.influxdata.com/influxdb/v2.0/reference/syntax/line-protocol/
    public func writeRecords(bucket: String? = nil,
                             org: String? = nil,
                             precision: InfluxDBClient.WritePrecision = InfluxDBClient.defaultWritePrecision,
                             records: [String],
                             responseQueue: DispatchQueue = .main,
                             completion: @escaping (_ response: Void?,
                                                    _ error: InfluxDBClient.InfluxDBError?) -> Void) {
        postWrite(records, responseQueue) { result -> Void in
            switch result {
            case .success:
                completion((), nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /// Write a line of Line Protocol.
    ///
    /// - Parameters:
    ///   - bucket:  The destination bucket for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - org: The destination organization for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - precision: The precision for the unix timestamps within the body line-protocol.
    ///   - record: The line of InfluxDB Line Protocol.
    ///   - responseQueue: The queue on which api response is dispatched.
    ///   - completion: completion handler to receive the `Swift.Result`
    ///
    /// - SeeAlso: `Swift.Result`
    /// - SeeAlso: https://docs.influxdata.com/influxdb/v2.0/reference/syntax/line-protocol/
    public func writeRecord(bucket: String? = nil,
                            org: String? = nil,
                            precision: InfluxDBClient.WritePrecision = InfluxDBClient.defaultWritePrecision,
                            record: String,
                            responseQueue: DispatchQueue = .main,
                            completion: @escaping (
                                    _ result: Swift.Result<Void, InfluxDBClient.InfluxDBError>) -> Void) {
        self.writeRecords(
                bucket: bucket,
                org: org,
                precision: precision,
                records: [record],
                responseQueue: responseQueue,
                completion: completion)
    }

    /// Write lines of Line Protocol.
    ///
    /// - Parameters:
    ///   - bucket:  The destination bucket for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - org: The destination organization for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - precision: The precision for the unix timestamps within the body line-protocol.
    ///   - records: The lines in InfluxDB Line Protocol.
    ///   - responseQueue: The queue on which api response is dispatched.
    ///   - completion: completion handler to receive the `Swift.Result`
    ///
    /// - SeeAlso: `Swift.Result`
    /// - SeeAlso: https://docs.influxdata.com/influxdb/v2.0/reference/syntax/line-protocol/
    public func writeRecords(bucket: String? = nil,
                             org: String? = nil,
                             precision: InfluxDBClient.WritePrecision = InfluxDBClient.defaultWritePrecision,
                             records: [String],
                             responseQueue: DispatchQueue = .main,
                             completion: @escaping (
                                     _ result: Swift.Result<Void, InfluxDBClient.InfluxDBError>) -> Void) {
        postWrite(records, responseQueue) { result -> Void in
            switch result {
            case .success:
                completion(.success(()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    #if canImport(Combine)
    /// Write a line of Line Protocol.
    ///
    /// - Parameters:
    ///   - bucket:  The destination bucket for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - org: The destination organization for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - precision: The precision for the unix timestamps within the body line-protocol.
    ///   - record: The line of InfluxDB Line Protocol.
    ///   - responseQueue: The queue on which api response is dispatched.
    /// - Returns: Publisher to attach a subscriber
    ///
    /// - SeeAlso: https://docs.influxdata.com/influxdb/v2.0/reference/syntax/line-protocol/
    @available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public func writeRecord(bucket: String? = nil,
                            org: String? = nil,
                            precision: InfluxDBClient.WritePrecision = InfluxDBClient.defaultWritePrecision,
                            record: String,
                            responseQueue: DispatchQueue = .main) -> AnyPublisher<Void, InfluxDBClient.InfluxDBError> {
        self.writeRecords(
                bucket: bucket,
                org: org,
                precision: precision,
                records: [record],
                responseQueue: responseQueue)
    }

    /// Write lines of Line Protocol.
    ///
    /// - Parameters:
    ///   - bucket:  The destination bucket for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - org: The destination organization for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - precision: The precision for the unix timestamps within the body line-protocol.
    ///   - records: The lines in InfluxDB Line Protocol.
    ///   - responseQueue: The queue on which api response is dispatched.
    /// - Returns: Publisher to attach a subscriber
    ///
    /// - SeeAlso: https://docs.influxdata.com/influxdb/v2.0/reference/syntax/line-protocol/
    @available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public func writeRecords(bucket: String? = nil,
                             org: String? = nil,
                             precision: InfluxDBClient.WritePrecision = InfluxDBClient.defaultWritePrecision,
                             records: [String],
                             responseQueue: DispatchQueue = .main)
                    -> AnyPublisher<Void, InfluxDBClient.InfluxDBError> {
        Future<Void, InfluxDBClient.InfluxDBError> { promise in
            self.postWrite(records, responseQueue) { result -> Void in
                switch result {
                case .success:
                    promise(.success(()))
                case let .failure(error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    #endif

    // swiftlint:disable function_body_length
    internal func postWrite(_ records: [String],
                            _ responseQueue: DispatchQueue,
                            _ completion: @escaping (
                                    _ result: Swift.Result<Void, InfluxDBClient.InfluxDBError>) -> Void) {
        do {
            guard let url = URL(string: client.url + "/api/v2/write") else {
                throw InfluxDBClient.InfluxDBError.error(
                        -1,
                        nil,
                        nil,
                        InfluxDBClient.InfluxDBError.generic("Invalid URL"))
            }

            let lineProtocol = records
                    .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
                    .joined(separator: "\\n")

            var request = URLRequest(url: url)
            request.httpMethod = "POST"

            // Headers
            request.setValue("text/plain; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("identity", forHTTPHeaderField: "Accept-Encoding")
            request.setValue(client.options.enableGzip ? "gzip" : "identity", forHTTPHeaderField: "Content-Encoding")

            client.session.configuration.httpAdditionalHeaders?.forEach { key, value in
                request.setValue("\(value)", forHTTPHeaderField: "\(key)")
            }

            // Body
            var body = lineProtocol.data(using: .utf8)
            if let data = body, client.options.enableGzip {
                body = try data.gzipped()
            }
            request.httpBody = body

            let task = client.session.dataTask(with: request) { data, response, error in
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

                    completion(.success(Void()))
                }
            }

            task.resume()
        } catch {
            responseQueue.async {
                completion(.failure(InfluxDBClient.InfluxDBError.error(415, nil, nil, error)))
            }
        }
    }
    // swiftlint:enable function_body_length
}
