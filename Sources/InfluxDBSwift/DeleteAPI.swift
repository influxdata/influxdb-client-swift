//
// Created by Jakub Bednář on 06/01/2021.
//

#if canImport(Combine)
import Combine
#endif
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Delete time series data from InfluxDB 2.x.
///
/// ### Example: ###
/// ````
/// let predicateRequest = DeletePredicateRequest(
///         start: Date(timeIntervalSince1970: 0),
///         stop: Date(),
///         predicate: "_measurement=\"server\" AND production=\"no\"")
///
/// client.deleteAPI.delete(predicate: predicateRequest, bucket: "my-bucket", org: "my-org") { result, error in
///     // For handle error
///     if let error = error {
///         print("Error:\n\n\(error)")
///     }
///
///     // For Success Delete
///     if result != nil {
///         print("Successfully data data by:\n\n\(predicateRequest)")
///     }
/// }
/// ````
public class DeleteAPI {
    /// Shared client.
    private let client: InfluxDBClient

    /// Create a new DeleteAPI for InfluxDB
    ///
    /// - Parameters
    ///    - client: Client with shared configuration and http library.
    init(client: InfluxDBClient) {
        self.client = client
    }

    /// Delete points from an InfluxDB by specified predicate.
    ///
    /// - Parameters:
    ///   - predicate: Delete predicate statement.
    ///   - bucket: Specifies the bucket to delete data from.
    ///   - bucketID: Specifies the bucket ID to delete data from.
    ///   - org: Specifies the organization to delete data from.
    ///   - orgID: Specifies the organization ID of the resource.
    ///   - responseQueue: The queue on which api response is dispatched.
    ///   - completion: completion handler to receive the data and the error objects
    ///
    /// - SeeAlso: https://docs.influxdata.com/influxdb/cloud/reference/syntax/delete-predicate/
    public func delete(predicate: DeletePredicateRequest,
                       bucket: String? = nil,
                       bucketID: String? = nil,
                       org: String? = nil,
                       orgID: String? = nil,
                       responseQueue: DispatchQueue = .main,
                       completion: @escaping (_ response: Void?,
                                              _ error: InfluxDBClient.InfluxDBError?) -> Void) {
        delete(
                predicate: predicate,
                bucket: bucket,
                bucketID: bucketID,
                org: org,
                orgID: orgID,
                responseQueue: responseQueue) { result -> Void in
            switch result {
            case .success:
                completion((), nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /// Delete points from an InfluxDB by specified predicate.
    ///
    /// - Parameters:
    ///   - predicate: Delete predicate statement.
    ///   - bucket: Specifies the bucket to delete data from.
    ///   - bucketID: Specifies the bucket ID to delete data from.
    ///   - org: Specifies the organization to delete data from.
    ///   - orgID: Specifies the organization ID of the resource.
    ///   - responseQueue: The queue on which api response is dispatched.
    ///   - completion: completion handler to receive the `Swift.Result`
    ///
    /// - SeeAlso: https://docs.influxdata.com/influxdb/cloud/reference/syntax/delete-predicate/
    public func delete(predicate: DeletePredicateRequest,
                       bucket: String? = nil,
                       bucketID: String? = nil,
                       org: String? = nil,
                       orgID: String? = nil,
                       responseQueue: DispatchQueue = .main,
                       completion: @escaping (
                               _ result: Swift.Result<Void, InfluxDBClient.InfluxDBError>) -> Void) {
        postDelete(predicate, bucket, bucketID, org, orgID, responseQueue) { result -> Void in
            switch result {
            case .success:
                completion(.success(()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    #if canImport(Combine)
    /// Delete points from an InfluxDB by specified predicate.
    ///
    /// - Parameters:
    ///   - predicate: Delete predicate statement.
    ///   - bucket: Specifies the bucket to delete data from.
    ///   - bucketID: Specifies the bucket ID to delete data from.
    ///   - org: Specifies the organization to delete data from.
    ///   - orgID: Specifies the organization ID of the resource.
    ///   - responseQueue: The queue on which api response is dispatched.
    ///   - completion: completion handler to receive the `Swift.Result`
    ///
    /// - SeeAlso: https://docs.influxdata.com/influxdb/cloud/reference/syntax/delete-predicate/
    @available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public func delete(predicate: DeletePredicateRequest,
                       bucket: String? = nil,
                       bucketID: String? = nil,
                       org: String? = nil,
                       orgID: String? = nil,
                       responseQueue: DispatchQueue = .main) -> AnyPublisher<Void, InfluxDBClient.InfluxDBError> {
        Future<Void, InfluxDBClient.InfluxDBError> { promise in
            self.postDelete(predicate, bucket, bucketID, org, orgID, responseQueue) { result -> Void in
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

    // swiftlint:disable function_parameter_count
    private func postDelete(_ predicate: DeletePredicateRequest,
                            _ bucket: String?,
                            _ bucketID: String?,
                            _ org: String?,
                            _ orgID: String?,
                            _ responseQueue: DispatchQueue,
                            _ completion: @escaping (
                                    _ result: Swift.Result<Void, InfluxDBClient.InfluxDBError>) -> Void) {
        do {
            var components = URLComponents(string: client.url + "/api/v2/delete")
            components?.queryItems = APIHelper.mapValuesToQueryItems([
                "org": org,
                "bucket": bucket,
                "orgID": orgID,
                "bucketID": bucketID
            ])

            let body = try CodableHelper.encode(predicate).get()

            client.httpPost(
                    components,
                    "text/plain; charset=utf-8",
                    "application/json",
                    InfluxDBClient.GZIPMode.none,
                    body,
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

    // swiftlint:enable function_parameter_count
}
