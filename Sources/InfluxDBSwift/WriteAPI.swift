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

/// The asynchronous API to Write time-series data into InfluxDB 2.x.
///
/// ### Example: ###
/// ````
/// //
/// // Record defined as String
/// //
/// let recordString = "demo,type=string value=1i"
///
/// try await client.makeWriteAPI().write(record: recordString)
///
/// // For Success write
/// print("Successfully written data:\n\n\(recordString)")
///
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
///
/// try await client.makeWriteAPI().write(points: [recordPoint, recordPointDate])
///
/// // For Success write
/// print("Successfully written data:\n\n\([recordPoint, recordPointDate])")
///
/// //
/// // Record defined as Tuple
/// //
/// let recordTuple: InfluxDBClient.Point.Tuple
///     = (measurement: "demo", tags: ["type": "tuple"], fields: ["value": .int(3)], time: nil)
///
/// try await client.makeWriteAPI().write(tuple: recordTuple)
///
/// // For Success write
/// print("Successfully written data:\n\n\(recordTuple)")
///
/// ````
public struct WriteAPI: Sendable {
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
    ///   - record: The record to write.
    ///   - responseQueue: The queue on which api response is dispatched.
    ///   - completion: completion handler to receive the data and the error objects
    ///
    /// - SeeAlso: https://docs.influxdata.com/influxdb/latest/reference/syntax/line-protocol/
    public func write(bucket: String? = nil,
                      org: String? = nil,
                      precision: InfluxDBClient.TimestampPrecision? = nil,
                      record: String,
                      responseQueue: DispatchQueue = .main,
                      completion: @escaping (_ response: Void?,
                                             _ error: InfluxDBClient.InfluxDBError?) -> Void) {
        self.write(
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
    ///   - records: The records to write.
    ///   - responseQueue: The queue on which api response is dispatched.
    ///   - completion: handler to receive the data and the error objects
    ///
    /// - SeeAlso: https://docs.influxdata.com/influxdb/latest/reference/syntax/line-protocol/
    public func write(bucket: String? = nil,
                      org: String? = nil,
                      precision: InfluxDBClient.TimestampPrecision? = nil,
                      records: [String],
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
    ///   - point: The `Point` to write.
    ///   - responseQueue: The queue on which api response is dispatched.
    ///   - completion: completion handler to receive the data and the error objects
    ///
    /// - SeeAlso: https://docs.influxdata.com/influxdb/latest/reference/syntax/line-protocol/
    public func write(bucket: String? = nil,
                      org: String? = nil,
                      precision: InfluxDBClient.TimestampPrecision? = nil,
                      point: InfluxDBClient.Point,
                      responseQueue: DispatchQueue = .main,
                      completion: @escaping (_ response: Void?,
                                             _ error: InfluxDBClient.InfluxDBError?) -> Void) {
        self.write(
                bucket: bucket,
                org: org,
                precision: precision,
                points: [point],
                responseQueue: responseQueue,
                completion: completion)
    }

    /// Write time-series data into InfluxDB.
    ///
    /// - Parameters:
    ///   - bucket:  The destination bucket for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - org: The destination organization for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - precision: The precision for the unix timestamps within the body line-protocol.
    ///   - points: The `Points` to write.
    ///   - responseQueue: The queue on which api response is dispatched.
    ///   - completion: handler to receive the data and the error objects
    ///
    /// - SeeAlso: https://docs.influxdata.com/influxdb/latest/reference/syntax/line-protocol/
    public func write(bucket: String? = nil,
                      org: String? = nil,
                      precision: InfluxDBClient.TimestampPrecision? = nil,
                      points: [InfluxDBClient.Point],
                      responseQueue: DispatchQueue = .main,
                      completion: @escaping (_ response: Void?,
                                             _ error: InfluxDBClient.InfluxDBError?) -> Void) {
        postWrite(bucket, org, precision, points, responseQueue) { result -> Void in
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
    ///   - tuple: The `Tuple` to write.
    ///   - responseQueue: The queue on which api response is dispatched.
    ///   - completion: completion handler to receive the data and the error objects
    ///
    /// - SeeAlso: https://docs.influxdata.com/influxdb/latest/reference/syntax/line-protocol/
    public func write(bucket: String? = nil,
                      org: String? = nil,
                      precision: InfluxDBClient.TimestampPrecision? = nil,
                      tuple: InfluxDBClient.Point.Tuple,
                      responseQueue: DispatchQueue = .main,
                      completion: @escaping (_ response: Void?,
                                             _ error: InfluxDBClient.InfluxDBError?) -> Void) {
        self.write(
                bucket: bucket,
                org: org,
                precision: precision,
                tuples: [tuple],
                responseQueue: responseQueue,
                completion: completion)
    }

    /// Write time-series data into InfluxDB.
    ///
    /// - Parameters:
    ///   - bucket:  The destination bucket for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - org: The destination organization for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - precision: The precision for the unix timestamps within the body line-protocol.
    ///   - tuples: The `Tuples` to write.
    ///   - responseQueue: The queue on which api response is dispatched.
    ///   - completion: handler to receive the data and the error objects
    ///
    /// - SeeAlso: https://docs.influxdata.com/influxdb/latest/reference/syntax/line-protocol/
    public func write(bucket: String? = nil,
                      org: String? = nil,
                      precision: InfluxDBClient.TimestampPrecision? = nil,
                      tuples: [InfluxDBClient.Point.Tuple],
                      responseQueue: DispatchQueue = .main,
                      completion: @escaping (_ response: Void?,
                                             _ error: InfluxDBClient.InfluxDBError?) -> Void) {
        postWrite(bucket, org, precision, tuples, responseQueue) { result -> Void in
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
    ///   - record: The record to write.
    ///   - responseQueue: The queue on which api response is dispatched.
    ///   - completion: completion handler to receive the `Swift.Result`
    ///
    /// - SeeAlso: `Swift.Result`
    /// - SeeAlso: https://docs.influxdata.com/influxdb/latest/reference/syntax/line-protocol/
    public func write(bucket: String? = nil,
                      org: String? = nil,
                      precision: InfluxDBClient.TimestampPrecision? = nil,
                      record: String,
                      responseQueue: DispatchQueue = .main,
                      completion: @escaping (
                              _ result: Swift.Result<Void, InfluxDBClient.InfluxDBError>) -> Void) {
        self.write(
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
    /// - SeeAlso: https://docs.influxdata.com/influxdb/latest/reference/syntax/line-protocol/
    public func write(bucket: String? = nil,
                      org: String? = nil,
                      precision: InfluxDBClient.TimestampPrecision? = nil,
                      records: [String],
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

    /// Write time-series data into InfluxDB.
    ///
    /// - Parameters:
    ///   - bucket:  The destination bucket for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - org: The destination organization for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - precision: The precision for the unix timestamps within the body line-protocol.
    ///   - point: The `Point` to write.
    ///   - responseQueue: The queue on which api response is dispatched.
    ///   - completion: completion handler to receive the `Swift.Result`
    ///
    /// - SeeAlso: `Swift.Result`
    /// - SeeAlso: https://docs.influxdata.com/influxdb/latest/reference/syntax/line-protocol/
    public func write(bucket: String? = nil,
                      org: String? = nil,
                      precision: InfluxDBClient.TimestampPrecision? = nil,
                      point: InfluxDBClient.Point,
                      responseQueue: DispatchQueue = .main,
                      completion: @escaping (
                              _ result: Swift.Result<Void, InfluxDBClient.InfluxDBError>) -> Void) {
        self.write(
                bucket: bucket,
                org: org,
                precision: precision,
                points: [point],
                responseQueue: responseQueue,
                completion: completion)
    }

    /// Write time-series data into InfluxDB.
    ///
    /// - Parameters:
    ///   - bucket:  The destination bucket for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - org: The destination organization for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - precision: The precision for the unix timestamps within the body line-protocol.
    ///   - points: The `Points` to write.
    ///   - responseQueue: The queue on which api response is dispatched.
    ///   - completion: completion handler to receive the `Swift.Result`
    ///
    /// - SeeAlso: `Swift.Result`
    /// - SeeAlso: https://docs.influxdata.com/influxdb/latest/reference/syntax/line-protocol/
    public func write(bucket: String? = nil,
                      org: String? = nil,
                      precision: InfluxDBClient.TimestampPrecision? = nil,
                      points: [InfluxDBClient.Point],
                      responseQueue: DispatchQueue = .main,
                      completion: @escaping (
                              _ result: Swift.Result<Void, InfluxDBClient.InfluxDBError>) -> Void) {
        postWrite(bucket, org, precision, points, responseQueue) { result -> Void in
            switch result {
            case .success:
                completion(.success(()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    /// Write time-series data into InfluxDB.
    ///
    /// - Parameters:
    ///   - bucket:  The destination bucket for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - org: The destination organization for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - precision: The precision for the unix timestamps within the body line-protocol.
    ///   - tuple: The `Tuple` to write.
    ///   - responseQueue: The queue on which api response is dispatched.
    ///   - completion: completion handler to receive the `Swift.Result`
    ///
    /// - SeeAlso: `Swift.Result`
    /// - SeeAlso: https://docs.influxdata.com/influxdb/latest/reference/syntax/line-protocol/
    public func write(bucket: String? = nil,
                      org: String? = nil,
                      precision: InfluxDBClient.TimestampPrecision? = nil,
                      tuple: InfluxDBClient.Point.Tuple,
                      responseQueue: DispatchQueue = .main,
                      completion: @escaping (
                              _ result: Swift.Result<Void, InfluxDBClient.InfluxDBError>) -> Void) {
        self.write(
                bucket: bucket,
                org: org,
                precision: precision,
                tuples: [tuple],
                responseQueue: responseQueue,
                completion: completion)
    }

    /// Write time-series data into InfluxDB.
    ///
    /// - Parameters:
    ///   - bucket:  The destination bucket for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - org: The destination organization for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - precision: The precision for the unix timestamps within the body line-protocol.
    ///   - tuples: The `Tuples` to write.
    ///   - responseQueue: The queue on which api response is dispatched.
    ///   - completion: completion handler to receive the `Swift.Result`
    ///
    /// - SeeAlso: `Swift.Result`
    /// - SeeAlso: https://docs.influxdata.com/influxdb/latest/reference/syntax/line-protocol/
    public func write(bucket: String? = nil,
                      org: String? = nil,
                      precision: InfluxDBClient.TimestampPrecision? = nil,
                      tuples: [InfluxDBClient.Point.Tuple],
                      responseQueue: DispatchQueue = .main,
                      completion: @escaping (
                              _ result: Swift.Result<Void, InfluxDBClient.InfluxDBError>) -> Void) {
        postWrite(bucket, org, precision, tuples, responseQueue) { result -> Void in
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
    ///   - record: The record to write.
    ///   - responseQueue: The queue on which api response is dispatched.
    /// - Returns: Publisher to attach a subscriber
    ///
    /// - SeeAlso: https://docs.influxdata.com/influxdb/latest/reference/syntax/line-protocol/
    @available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public func write(bucket: String? = nil,
                      org: String? = nil,
                      precision: InfluxDBClient.TimestampPrecision? = nil,
                      record: String,
                      responseQueue: DispatchQueue = .main) -> AnyPublisher<Void, InfluxDBClient.InfluxDBError> {
        self.write(
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
    ///   - records: The records to write.
    ///   - responseQueue: The queue on which api response is dispatched.
    /// - Returns: Publisher to attach a subscriber
    ///
    /// - SeeAlso: https://docs.influxdata.com/influxdb/latest/reference/syntax/line-protocol/
    @available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public func write(bucket: String? = nil,
                      org: String? = nil,
                      precision: InfluxDBClient.TimestampPrecision? = nil,
                      records: [String],
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

    /// Write time-series data into InfluxDB.
    ///
    /// - Parameters:
    ///   - bucket:  The destination bucket for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - org: The destination organization for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - precision: The precision for the unix timestamps within the body line-protocol.
    ///   - point: The `Point` to write.
    ///   - responseQueue: The queue on which api response is dispatched.
    /// - Returns: Publisher to attach a subscriber
    ///
    /// - SeeAlso: https://docs.influxdata.com/influxdb/latest/reference/syntax/line-protocol/
    @available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public func write(bucket: String? = nil,
                      org: String? = nil,
                      precision: InfluxDBClient.TimestampPrecision? = nil,
                      point: InfluxDBClient.Point,
                      responseQueue: DispatchQueue = .main) -> AnyPublisher<Void, InfluxDBClient.InfluxDBError> {
        self.write(
                bucket: bucket,
                org: org,
                precision: precision,
                points: [point],
                responseQueue: responseQueue)
    }

    /// Write time-series data into InfluxDB.
    ///
    /// - Parameters:
    ///   - bucket:  The destination bucket for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - org: The destination organization for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - precision: The precision for the unix timestamps within the body line-protocol.
    ///   - points: The `Point` to write.
    ///   - responseQueue: The queue on which api response is dispatched.
    /// - Returns: Publisher to attach a subscriber
    ///
    /// - SeeAlso: https://docs.influxdata.com/influxdb/latest/reference/syntax/line-protocol/
    @available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public func write(bucket: String? = nil,
                      org: String? = nil,
                      precision: InfluxDBClient.TimestampPrecision? = nil,
                      points: [InfluxDBClient.Point],
                      responseQueue: DispatchQueue = .main)
                    -> AnyPublisher<Void, InfluxDBClient.InfluxDBError> {
        Future<Void, InfluxDBClient.InfluxDBError> { promise in
            self.postWrite(bucket, org, precision, points, responseQueue) { result -> Void in
                switch result {
                case .success:
                    promise(.success(()))
                case let .failure(error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    /// Write time-series data into InfluxDB.
    ///
    /// - Parameters:
    ///   - bucket:  The destination bucket for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - org: The destination organization for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - precision: The precision for the unix timestamps within the body line-protocol.
    ///   - tuple: The `Tuple` to write.
    ///   - responseQueue: The queue on which api response is dispatched.
    /// - Returns: Publisher to attach a subscriber
    ///
    /// - SeeAlso: https://docs.influxdata.com/influxdb/latest/reference/syntax/line-protocol/
    @available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public func write(bucket: String? = nil,
                      org: String? = nil,
                      precision: InfluxDBClient.TimestampPrecision? = nil,
                      tuple: InfluxDBClient.Point.Tuple,
                      responseQueue: DispatchQueue = .main) -> AnyPublisher<Void, InfluxDBClient.InfluxDBError> {
        self.write(
                bucket: bucket,
                org: org,
                precision: precision,
                tuples: [tuple],
                responseQueue: responseQueue)
    }

    /// Write time-series data into InfluxDB.
    ///
    /// - Parameters:
    ///   - bucket:  The destination bucket for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - org: The destination organization for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - precision: The precision for the unix timestamps within the body line-protocol.
    ///   - tuples: The `Tuples` to write.
    ///   - responseQueue: The queue on which api response is dispatched.
    /// - Returns: Publisher to attach a subscriber
    ///
    /// - SeeAlso: https://docs.influxdata.com/influxdb/latest/reference/syntax/line-protocol/
    @available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public func write(bucket: String? = nil,
                      org: String? = nil,
                      precision: InfluxDBClient.TimestampPrecision? = nil,
                      tuples: [InfluxDBClient.Point.Tuple],
                      responseQueue: DispatchQueue = .main)
                    -> AnyPublisher<Void, InfluxDBClient.InfluxDBError> {
        Future<Void, InfluxDBClient.InfluxDBError> { promise in
            self.postWrite(bucket, org, precision, tuples, responseQueue) { result -> Void in
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

    #if swift(>=5.5)
    /// Write time-series data asynchronously into InfluxDB.
    ///
    /// - Parameters:
    ///   - bucket:  The destination bucket for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - org: The destination organization for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - precision: The precision for the unix timestamps within the body line-protocol.
    ///   - record: The record to write.
    ///   - responseQueue: The queue on which api response is dispatched.
    ///
    /// - SeeAlso: https://docs.influxdata.com/influxdb/latest/reference/syntax/line-protocol/
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func write(bucket: String? = nil,
                      org: String? = nil,
                      precision: InfluxDBClient.TimestampPrecision? = nil,
                      record: String,
                      responseQueue: DispatchQueue = .main) async throws {
        try await self.write(
                bucket: bucket,
                org: org,
                precision: precision,
                records: [record],
                responseQueue: responseQueue)
    }

    /// Write time-series data asynchronously into InfluxDB.
    ///
    /// - Parameters:
    ///   - bucket:  The destination bucket for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - org: The destination organization for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - precision: The precision for the unix timestamps within the body line-protocol.
    ///   - records: The records to write.
    ///   - responseQueue: The queue on which api response is dispatched.
    ///
    /// - SeeAlso: https://docs.influxdata.com/influxdb/latest/reference/syntax/line-protocol/
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func write(bucket: String? = nil,
                      org: String? = nil,
                      precision: InfluxDBClient.TimestampPrecision? = nil,
                      records: [String],
                      responseQueue: DispatchQueue = .main) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) -> Void in
            self.postWrite(bucket, org, precision, records, responseQueue) { result -> Void in
                switch result {
                case .success:
                    continuation.resume(returning: ())
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    /// Write time-series data asynchronously into InfluxDB.
    ///
    /// - Parameters:
    ///   - bucket:  The destination bucket for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - org: The destination organization for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - precision: The precision for the unix timestamps within the body line-protocol.
    ///   - point: The `Point` to write.
    ///   - responseQueue: The queue on which api response is dispatched.
    ///
    /// - SeeAlso: https://docs.influxdata.com/influxdb/latest/reference/syntax/line-protocol/
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func write(bucket: String? = nil,
                      org: String? = nil,
                      precision: InfluxDBClient.TimestampPrecision? = nil,
                      point: InfluxDBClient.Point,
                      responseQueue: DispatchQueue = .main) async throws {
        try await self.write(
                bucket: bucket,
                org: org,
                precision: precision,
                points: [point],
                responseQueue: responseQueue)
    }

    /// Write time-series data asynchronously into InfluxDB.
    ///
    /// - Parameters:
    ///   - bucket:  The destination bucket for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - org: The destination organization for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - precision: The precision for the unix timestamps within the body line-protocol.
    ///   - points: The `Points` to write.
    ///   - responseQueue: The queue on which api response is dispatched.
    ///
    /// - SeeAlso: https://docs.influxdata.com/influxdb/latest/reference/syntax/line-protocol/
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func write(bucket: String? = nil,
                      org: String? = nil,
                      precision: InfluxDBClient.TimestampPrecision? = nil,
                      points: [InfluxDBClient.Point],
                      responseQueue: DispatchQueue = .main) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) -> Void in
            self.postWrite(bucket, org, precision, points, responseQueue) { result -> Void in
                switch result {
                case .success:
                    continuation.resume(returning: ())
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    /// Write time-series data asynchronously into InfluxDB.
    ///
    /// - Parameters:
    ///   - bucket:  The destination bucket for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - org: The destination organization for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - precision: The precision for the unix timestamps within the body line-protocol.
    ///   - tuple: The `Tuple` to write.
    ///   - responseQueue: The queue on which api response is dispatched.
    ///
    /// - SeeAlso: https://docs.influxdata.com/influxdb/latest/reference/syntax/line-protocol/
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func write(bucket: String? = nil,
                      org: String? = nil,
                      precision: InfluxDBClient.TimestampPrecision? = nil,
                      tuple: InfluxDBClient.Point.Tuple,
                      responseQueue: DispatchQueue = .main) async throws {
        try await self.write(
                bucket: bucket,
                org: org,
                precision: precision,
                tuples: [tuple],
                responseQueue: responseQueue)
    }

    /// Write time-series data asynchronously into InfluxDB.
    ///
    /// - Parameters:
    ///   - bucket:  The destination bucket for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - org: The destination organization for writes. Takes either the `ID` or `Name` interchangeably.
    ///   - precision: The precision for the unix timestamps within the body line-protocol.
    ///   - tuples: The `Tuples` to write.
    ///   - responseQueue: The queue on which api response is dispatched.
    ///
    /// - SeeAlso: https://docs.influxdata.com/influxdb/latest/reference/syntax/line-protocol/
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func write(bucket: String? = nil,
                      org: String? = nil,
                      precision: InfluxDBClient.TimestampPrecision? = nil,
                      tuples: [InfluxDBClient.Point.Tuple],
                      responseQueue: DispatchQueue = .main) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) -> Void in
            postWrite(bucket, org, precision, tuples, responseQueue) { result -> Void in
                switch result {
                case .success:
                    continuation.resume(returning: ())
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    #endif

    // swiftlint:disable function_parameter_count
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

            // Query parameters
            components?.queryItems = [
                URLQueryItem(name: "bucket", value: bucket),
                URLQueryItem(name: "org", value: org),
                URLQueryItem(name: "precision", value: precision.rawValue)
            ]

            // Body
            var lps = [String]()
            try toLineProtocol(precision: precision, any: records, defaultTags: pointSettings?.evaluate(), lps: &lps)
            let body: Data! = lps.joined(separator: "\n").data(using: .utf8)
            // Without data => log information
            if body.isEmpty {
                print("There is nothing to write for following input: \(lps)")
                completion(.success(()))
                return
            }

            // HTTP post
            client.httpRequest(
                    components,
                    "text/plain; charset=utf-8",
                    "application/json",
                    InfluxDBClient.GZIPMode.request,
                    body,
                    "POST",
                    responseQueue) { result -> Void in
                switch result {
                case .success:
                    completion(.success(()))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        } catch {
            responseQueue.async {
                completion(.failure(InfluxDBClient.InfluxDBError.error(415, nil, nil, error)))
            }
        }
    }

    private func toLineProtocol(precision: InfluxDBClient.TimestampPrecision,
                                any: Any,
                                defaultTags: [String: String?]?,
                                lps: inout [String]) throws {
        // To avoid: "Could not cast value of type 'InfluxDBSwift.InfluxDBClient.Point' to 'Foundation.NSObject'."
        // on Linux - see:
        // https://app.circleci.com/pipelines/github/influxdata
        // /influxdb-client-swift/315/workflows/8467a324-6bbf-47ca-a2cf-6ff9d820385d/jobs/1042
        if type(of: any) == InfluxDBClient.Point.self {
            if let point = any as? InfluxDBClient.Point {
                try toLineProtocol(precision: precision, point: point, defaultTags: defaultTags, lps: &lps)
            }
        } else {
            switch any {
            case let string as String:
                toLineProtocol(precision: precision, record: string, defaultTags: defaultTags, lps: &lps)
            case let tuple as InfluxDBClient.Point.Tuple:
                let point = InfluxDBClient.Point.fromTuple(tuple)
                try toLineProtocol(precision: precision, point: point, defaultTags: defaultTags, lps: &lps)
            case let array as [Any]:
                try array.forEach { item in
                    try toLineProtocol(precision: precision, any: item, defaultTags: defaultTags, lps: &lps)
                }
            default:
                throw InfluxDBClient.InfluxDBError
                        .generic("Record type is not supported: \(any) with type: \(type(of: any))")
            }
        }
    }

    private func toLineProtocol(precision: InfluxDBClient.TimestampPrecision,
                                point: InfluxDBClient.Point,
                                defaultTags: [String: String?]?,
                                lps: inout [String]) throws {
        if let lineProtocol = try point.toLineProtocol(precision: precision, defaultTags: defaultTags) {
            return toLineProtocol(
                    precision: precision,
                    record: lineProtocol,
                    defaultTags: defaultTags,
                    lps: &lps)
        }
    }

    private func toLineProtocol(precision: InfluxDBClient.TimestampPrecision,
                                record: String,
                                defaultTags: [String: String?]?,
                                lps: inout [String]) {
        guard !record.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        lps.append(record)
    }

    // swiftlint:enable function_parameter_count
}
