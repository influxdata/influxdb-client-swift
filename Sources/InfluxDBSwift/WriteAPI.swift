//
// Created by Jakub Bednář on 05/11/2020.
//

#if canImport(Combine)
import Combine
#endif
import Foundation

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
        postWrite(responseQueue) { result -> Void in
            switch result {
            case .success:
                completion((), nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
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
        self.writeRecord(
                bucket: bucket,
                org: org,
                precision: precision,
                record: records.joined(separator: "\n"),
                responseQueue: responseQueue,
                completion: completion)
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
        postWrite(responseQueue) { result -> Void in
            switch result {
            case .success:
                completion(.success(()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
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
        self.writeRecord(
                bucket: bucket,
                org: org,
                precision: precision,
                record: records.joined(separator: "\n"),
                responseQueue: responseQueue,
                completion: completion)
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
        Future<Void, InfluxDBClient.InfluxDBError> { promise in
            self.postWrite(responseQueue) { result -> Void in
                switch result {
                case .success:
                    promise(.success(()))
                case let .failure(error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
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
        self.writeRecord(
                bucket: bucket,
                org: org,
                precision: precision,
                record: records.joined(separator: "\n"),
                responseQueue: responseQueue)
    }
    #endif

    internal func postWrite(_ responseQueue: DispatchQueue,
                            _ completion: @escaping (
                                    _ result: Swift.Result<Void, InfluxDBClient.InfluxDBError>) -> Void) {
    }
}
