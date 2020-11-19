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

    /// Write time-series data into InfluxDB.
    ///
    /// - Parameters:
    ///   - bucket:  The destination bucket for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - org: The destination organization for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - precision: The precision for the unix timestamps within the body line-protocol.
    ///   - record: The record to write. It can be `String`,  `Point` or `Tuple`.
    ///   - responseQueue: The queue on which api response is dispatched.
    ///   - completion: completion handler to receive the data and the error objects
    ///
    /// - SeeAlso: https://docs.influxdata.com/influxdb/v2.0/reference/syntax/line-protocol/
    public func writeRecord(bucket: String? = nil,
                            org: String? = nil,
                            precision: InfluxDBClient.WritePrecision? = nil,
                            record: Any,
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

    /// Write time-series data into InfluxDB.
    ///
    /// - Parameters:
    ///   - bucket:  The destination bucket for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - org: The destination organization for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - precision: The precision for the unix timestamps within the body line-protocol.
    ///   - records: The records to write. It can be `String`,  `Point` or `Tuple`.
    ///   - responseQueue: The queue on which api response is dispatched.
    ///   - completion handler to receive the data and the error objects
    ///
    /// - SeeAlso: https://docs.influxdata.com/influxdb/v2.0/reference/syntax/line-protocol/
    public func writeRecords(bucket: String? = nil,
                             org: String? = nil,
                             precision: InfluxDBClient.WritePrecision? = nil,
                             records: [Any],
                             responseQueue: DispatchQueue = .main,
                             completion: @escaping (_ response: Void?,
                                                    _ error: InfluxDBClient.InfluxDBError?) -> Void) {
        postWrite(bucket, org, precision, records, responseQueue) { result -> Void in
            switch result {
            case .success:
                completion((), nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /// Write time-series data into InfluxDB.
    ///
    /// - Parameters:
    ///   - bucket:  The destination bucket for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - org: The destination organization for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - precision: The precision for the unix timestamps within the body line-protocol.
    ///   - record: The record to write. It can be `String`,  `Point` or `Tuple`.
    ///   - responseQueue: The queue on which api response is dispatched.
    ///   - completion: completion handler to receive the `Swift.Result`
    ///
    /// - SeeAlso: `Swift.Result`
    /// - SeeAlso: https://docs.influxdata.com/influxdb/v2.0/reference/syntax/line-protocol/
    public func writeRecord(bucket: String? = nil,
                            org: String? = nil,
                            precision: InfluxDBClient.WritePrecision? = nil,
                            record: Any,
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

    /// Write time-series data into InfluxDB.
    ///
    /// - Parameters:
    ///   - bucket:  The destination bucket for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - org: The destination organization for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - precision: The precision for the unix timestamps within the body line-protocol.
    ///   - records: The records to write. It can be `String`,  `Point` or `Tuple`.
    ///   - responseQueue: The queue on which api response is dispatched.
    ///   - completion: completion handler to receive the `Swift.Result`
    ///
    /// - SeeAlso: `Swift.Result`
    /// - SeeAlso: https://docs.influxdata.com/influxdb/v2.0/reference/syntax/line-protocol/
    public func writeRecords(bucket: String? = nil,
                             org: String? = nil,
                             precision: InfluxDBClient.WritePrecision? = nil,
                             records: [Any],
                             responseQueue: DispatchQueue = .main,
                             completion: @escaping (
                                     _ result: Swift.Result<Void, InfluxDBClient.InfluxDBError>) -> Void) {
        postWrite(bucket, org, precision, records, responseQueue) { result -> Void in
            switch result {
            case .success:
                completion(.success(()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    #if canImport(Combine)
    /// Write time-series data into InfluxDB.
    ///
    /// - Parameters:
    ///   - bucket:  The destination bucket for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - org: The destination organization for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - precision: The precision for the unix timestamps within the body line-protocol.
    ///   - record: The record to write. It can be `String`,  `Point` or `Tuple`.
    ///   - responseQueue: The queue on which api response is dispatched.
    /// - Returns: Publisher to attach a subscriber
    ///
    /// - SeeAlso: https://docs.influxdata.com/influxdb/v2.0/reference/syntax/line-protocol/
    @available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public func writeRecord(bucket: String? = nil,
                            org: String? = nil,
                            precision: InfluxDBClient.WritePrecision? = nil,
                            record: Any,
                            responseQueue: DispatchQueue = .main) -> AnyPublisher<Void, InfluxDBClient.InfluxDBError> {
        self.writeRecords(
                bucket: bucket,
                org: org,
                precision: precision,
                records: [record],
                responseQueue: responseQueue)
    }

    /// Write time-series data into InfluxDB.
    ///
    /// - Parameters:
    ///   - bucket:  The destination bucket for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - org: The destination organization for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - precision: The precision for the unix timestamps within the body line-protocol.
    ///   - records: The records to write. It can be `String`,  `Point` or `Tuple`.
    ///   - responseQueue: The queue on which api response is dispatched.
    /// - Returns: Publisher to attach a subscriber
    ///
    /// - SeeAlso: https://docs.influxdata.com/influxdb/v2.0/reference/syntax/line-protocol/
    @available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public func writeRecords(bucket: String? = nil,
                             org: String? = nil,
                             precision: InfluxDBClient.WritePrecision? = nil,
                             records: [Any],
                             responseQueue: DispatchQueue = .main)
                    -> AnyPublisher<Void, InfluxDBClient.InfluxDBError> {
        Future<Void, InfluxDBClient.InfluxDBError> { promise in
            self.postWrite(bucket, org, precision, records, responseQueue) { result -> Void in
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

    // swiftlint:disable function_body_length function_parameter_count cyclomatic_complexity
    internal func postWrite(_ bucket: String?,
                            _ org: String?,
                            _ precision: InfluxDBClient.WritePrecision?,
                            _ records: [Any],
                            _ responseQueue: DispatchQueue,
                            _ completion: @escaping (
                                    _ result: Swift.Result<Void, InfluxDBClient.InfluxDBError>) -> Void) {
        do {
            var components = URLComponents(string: client.url + "/api/v2/write")

            guard let bucket = bucket ?? client.options.bucket else {
                throw InfluxDBClient.InfluxDBError
                        .generic("The bucket destination should be specified.")
            }

            guard let org = org ?? client.options.org else {
                throw InfluxDBClient.InfluxDBError
                        .generic("The org destination should be specified.")
            }

            let precision = precision ?? client.options.precision

            // we need sort batches by insertion time (for LP without timestamp)
            var batches: [InfluxDBClient.WritePrecision: (Int, [String])] = [:]
            try toLineProtocol(precision: precision, record: records, batches: &batches)

            try batches.sorted {
                $0.value.0 < $1.value.0
            }.forEach { key, values in
                components?.queryItems = [
                    URLQueryItem(name: "bucket", value: bucket),
                    URLQueryItem(name: "org", value: org),
                    URLQueryItem(name: "precision", value: key.rawValue)
                ]

                guard let url = components?.url else {
                    throw InfluxDBClient.InfluxDBError.error(
                            -1,
                            nil,
                            nil,
                            InfluxDBClient.InfluxDBError.generic("Invalid URL"))
                }

                var request = URLRequest(url: url)
                request.httpMethod = "POST"

                // Body
                var body: Data! = values.1.joined(separator: "\n").data(using: .utf8)
                if let data = body, client.options.enableGzip {
                    body = try data.gzipped()
                }
                request.httpBody = body

                // Headers
                request.setValue("text/plain; charset=utf-8", forHTTPHeaderField: "Content-Type")
                request.setValue(String(body.count), forHTTPHeaderField: "Content-Length")
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                request.setValue("identity", forHTTPHeaderField: "Accept-Encoding")
                request.setValue(
                        client.options.enableGzip ? "gzip" : "identity",
                        forHTTPHeaderField: "Content-Encoding")

                client.session.configuration.httpAdditionalHeaders?.forEach { key, value in
                    request.setValue("\(value)", forHTTPHeaderField: "\(key)")
                }

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
            }
        } catch {
            responseQueue.async {
                completion(.failure(InfluxDBClient.InfluxDBError.error(415, nil, nil, error)))
            }
        }
    }

    private func toLineProtocol(precision: InfluxDBClient.WritePrecision,
                                record: Any,
                                batches: inout [InfluxDBClient.WritePrecision: (Int, [String])]) throws {
        switch record {
        case let string as String:
            guard !string.trimmingCharacters(in: .whitespaces).isEmpty else {
                return
            }
            if var batch = batches[precision] {
                batch.1.append(string)
                batches[precision] = batch
            } else {
                batches[precision] = (batches.count, [string])
            }
        case let point as InfluxDBClient.Point:
            if let lineProtocol = try point.toLineProtocol() {
                try toLineProtocol(precision: point.precision, record: lineProtocol, batches: &batches)
            }
        case let tuple as (measurement: String, fields: [String?: Any?]):
            let point = InfluxDBClient.Point.fromTuple(
                    (measurement: tuple.measurement, tags: nil, fields: tuple.fields, time: nil),
                    precision: precision)
            try toLineProtocol(
                precision: precision,
                record: point,
                batches: &batches)
        case let tuple as (measurement: String, tags: [String?: String?]?, fields: [String?: Any?], time: Any?):
            try toLineProtocol(
                precision: precision,
                record: InfluxDBClient.Point.fromTuple(tuple, precision: precision),
                batches: &batches)
        case let tuple as (measurement: String, fields: [String?: Any?], time: Any?):
            let point = InfluxDBClient.Point.fromTuple(
                    (measurement: tuple.measurement, tags: nil, fields: tuple.fields, time: tuple.time),
                    precision: precision)
            try toLineProtocol(
                precision: precision,
                record: point,
                batches: &batches)
        case let tuple as (measurement: String, tags: [String?: String?]?, fields: [String?: Any?]):
            let point = InfluxDBClient.Point.fromTuple(
                    (measurement: tuple.measurement, tags: tuple.tags, fields: tuple.fields, time: nil),
                    precision: precision)
            try toLineProtocol(
                precision: precision,
                record: point,
                batches: &batches)
        case let array as [Any]:
            try array.forEach { item in
                try toLineProtocol(precision: precision, record: item, batches: &batches)
            }
        default:
            throw InfluxDBClient.InfluxDBError
                    .generic("Record type is not supported: \(record) with type: \(type(of: record))")
        }
    }

    // swiftlint:enable function_body_length function_parameter_count cyclomatic_complexity
}
