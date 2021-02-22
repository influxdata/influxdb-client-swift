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
///
/// ### Example: ###
/// ````
/// //
/// // Record defined as String
/// //
/// let recordString = "demo,type=string value=1i"
/// //
/// // Record defined as Data Point
/// //
/// let recordPoint = InfluxDBClient
///         .Point("demo")
///         .addTag(key: "type", value: "point")
///         .addField(key: "value", value: .int(2))
/// //
/// // Record defined as Data Point with Timestamp
/// //
/// let recordPointDate = InfluxDBClient
///         .Point("demo")
///         .addTag(key: "type", value: "point-timestamp")
///         .addField(key: "value", value: .int(2))
///         .time(time: .date(Date()))
/// //
/// // Record defined as Tuple
/// //
/// let recordTuple = (measurement: "demo", tags: ["type": "tuple"], fields: ["value": 3])
///
/// let records: [Any] = [recordString, recordPoint, recordPointDate, recordTuple]
///
/// client.createWriteAPI().writeRecords(records: records) { result, error in
///     // For handle error
///     if let error = error {
///         print("Error:\n\n\(error)")
///     }
///
///     // For Success write
///     if result != nil {
///         print("Successfully written data:\n\n\(records)")
///     }
/// }
/// ````
public class WriteAPI {
    /// Shared client.
    private let client: InfluxDBClient
    /// Settings for DataPoint.
    private let pointSettings: InfluxDBClient.PointSettings?

    /// Create a new WriteAPI for a InfluxDB
    ///
    /// - Parameters
    ///   - client: Client with shared configuration and http library.
    ///   - pointSettings: Default settings for DataPoint, useful for default tags.
    init(client: InfluxDBClient, pointSettings: InfluxDBClient.PointSettings? = nil) {
        self.client = client
        self.pointSettings = pointSettings
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
                            precision: InfluxDBClient.TimestampPrecision? = nil,
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
    ///   - completion: handler to receive the data and the error objects
    ///
    /// - SeeAlso: https://docs.influxdata.com/influxdb/v2.0/reference/syntax/line-protocol/
    public func writeRecords(bucket: String? = nil,
                             org: String? = nil,
                             precision: InfluxDBClient.TimestampPrecision? = nil,
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
                            precision: InfluxDBClient.TimestampPrecision? = nil,
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
                             precision: InfluxDBClient.TimestampPrecision? = nil,
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
                            precision: InfluxDBClient.TimestampPrecision? = nil,
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
                             precision: InfluxDBClient.TimestampPrecision? = nil,
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

    // swiftlint:disable function_body_length function_parameter_count
    private func postWrite(_ bucket: String?,
                           _ org: String?,
                           _ precision: InfluxDBClient.TimestampPrecision?,
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
            var batches: [InfluxDBClient.TimestampPrecision: (Int, [String])] = [:]
            let defaultTags = pointSettings?.evaluate()
            try toLineProtocol(precision: precision, record: records, defaultTags: defaultTags, batches: &batches)

            batches.sorted {
                $0.value.0 < $1.value.0
            }.forEach { key, values in
                components?.queryItems = [
                    URLQueryItem(name: "bucket", value: bucket),
                    URLQueryItem(name: "org", value: org),
                    URLQueryItem(name: "precision", value: key.rawValue)
                ]

                // Body
                let body: Data! = values.1.joined(separator: "\n").data(using: .utf8)

                client.httpPost(
                        components,
                        "text/plain; charset=utf-8",
                        "application/json",
                        InfluxDBClient.GZIPMode.request,
                        body,
                        responseQueue) { result -> Void in
                    switch result {
                    case .success:
                        completion(.success(()))
                    case let .failure(error):
                        completion(.failure(error))
                    }
                }
            }
        } catch {
            responseQueue.async {
                completion(.failure(InfluxDBClient.InfluxDBError.error(415, nil, nil, error)))
            }
        }
    }

    private func toLineProtocol(precision: InfluxDBClient.TimestampPrecision,
                                record: Any,
                                defaultTags: [String: String?]?,
                                batches: inout [InfluxDBClient.TimestampPrecision: (Int, [String])]) throws {
        // To avoid: "Could not cast value of type 'InfluxDBSwift.InfluxDBClient.Point' to 'Foundation.NSObject'."
        // on Linux - see:
        // https://app.circleci.com/pipelines/github/influxdata
        // /influxdb-client-swift/315/workflows/8467a324-6bbf-47ca-a2cf-6ff9d820385d/jobs/1042
        if type(of: record) == InfluxDBClient.Point.self {
            if let point = record as? InfluxDBClient.Point {
                if let lineProtocol = try point.toLineProtocol(defaultTags: defaultTags) {
                    let pointPrecision = point.time?.precision ?? InfluxDBClient.defaultTimestampPrecision
                    return try toLineProtocol(
                            precision: pointPrecision,
                            record: lineProtocol,
                            defaultTags: defaultTags,
                            batches: &batches)
                }
            }
        } else {
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
            case let tuple as (measurement: String, fields: [String?: Any?]):
                let point = InfluxDBClient.Point.fromTuple(
                        (measurement: tuple.measurement, tags: nil, fields: tuple.fields, time: nil),
                        precision: precision)
                try toLineProtocol(
                        precision: precision,
                        record: point,
                        defaultTags: defaultTags,
                        batches: &batches)
            case let tuple as (measurement: String, tags: [String?: String?]?, fields: [String?: Any?], time: Any?):
                try toLineProtocol(
                        precision: precision,
                        record: InfluxDBClient.Point.fromTuple(tuple, precision: precision),
                        defaultTags: defaultTags,
                        batches: &batches)
            case let tuple as (measurement: String, fields: [String?: Any?], time: Any?):
                let point = InfluxDBClient.Point.fromTuple(
                        (measurement: tuple.measurement, tags: nil, fields: tuple.fields, time: tuple.time),
                        precision: precision)
                try toLineProtocol(
                        precision: precision,
                        record: point,
                        defaultTags: defaultTags,
                        batches: &batches)
            case let tuple as (measurement: String, tags: [String?: String?]?, fields: [String?: Any?]):
                let point = InfluxDBClient.Point.fromTuple(
                        (measurement: tuple.measurement, tags: tuple.tags, fields: tuple.fields, time: nil),
                        precision: precision)
                try toLineProtocol(
                        precision: precision,
                        record: point,
                        defaultTags: defaultTags,
                        batches: &batches)
            case let array as [Any]:
                try array.forEach { item in
                    try toLineProtocol(precision: precision, record: item, defaultTags: defaultTags, batches: &batches)
                }
            default:
                throw InfluxDBClient.InfluxDBError
                        .generic("Record type is not supported: \(record) with type: \(type(of: record))")
            }
        }
    }

    // swiftlint:enable function_body_length function_parameter_count
}
