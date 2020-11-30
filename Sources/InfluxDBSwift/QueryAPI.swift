//
// Created by Jakub Bednář on 27/11/2020.
//

#if canImport(Combine)
import Combine
#endif
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Gzip
import CSV

/// The asynchronous API to Query InfluxDB 2.0.
public class QueryAPI {
    /// The default Query Dialect with annotation = ["datatype", "group", "default"]
    public static let defaultDialect = Dialect(annotations:
    [
        Dialect.Annotations.datatype,
        Dialect.Annotations.group,
        Dialect.Annotations._default
    ])
    /// Shared client.
    private let client: InfluxDBClient

    /// Create a new QueryAPI for a InfluxDB.
    ///
    /// - Parameters
    ///   - client: Client with shared configuration and http library.
    public init(client: InfluxDBClient) {
        self.client = client
    }

    /// QueryRaw executes a query and returns the response as a `Data`.
    ///
    /// - Parameters:
    ///   - query: The Flux query to execute.
    ///   - org: The organization executing the query. Takes either the `ID` or `Name` interchangeably.
    ///   - dialect: The Dialect are options to change the default CSV output format.
    ///   - responseQueue: The queue on which api response is dispatched.
    ///   - completion: handler to receive the data and the error objects
    public func queryRaw(query: String,
                         org: String? = nil,
                         dialect: Dialect = defaultDialect,
                         responseQueue: DispatchQueue = .main,
                         completion: @escaping (_ response: Data?, _ error: InfluxDBClient.InfluxDBError?) -> Void) {
        self.queryRaw(query: query, org: org, dialect: dialect, responseQueue: responseQueue) { result -> Void in
            switch result {
            case let .success(data):
                completion(data, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /// QueryRaw executes a query and returns the response as a `Data`.
    ///
    /// - Parameters:
    ///   - query: The Flux query to execute.
    ///   - org: The organization executing the query. Takes either the `ID` or `Name` interchangeably.
    ///   - dialect: The Dialect are options to change the default CSV output format.
    ///   - responseQueue: The queue on which api response is dispatched.
    ///   - completion: completion handler to receive the `Swift.Result`
    public func queryRaw(query: String,
                         org: String? = nil,
                         dialect: Dialect = defaultDialect,
                         responseQueue: DispatchQueue = .main,
                         completion: @escaping (_ result: Swift.Result<Data, InfluxDBClient.InfluxDBError>) -> Void) {
        postQuery(query, org, dialect, responseQueue, completion)
    }

    #if canImport(Combine)
    /// QueryRaw executes a query and returns the response as a `Data`.
    ///
    /// - Parameters:
    ///   - query: The Flux query to execute.
    ///   - org: The organization executing the query. Takes either the `ID` or `Name` interchangeably.
    ///   - dialect: The Dialect are options to change the default CSV output format.
    ///   - responseQueue: The queue on which api response is dispatched.
    /// - Returns: Publisher to attach a subscriber
    @available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public func queryRaw(query: String,
                         org: String? = nil,
                         dialect: Dialect = defaultDialect,
                         responseQueue: DispatchQueue = .main) -> AnyPublisher<Data, InfluxDBClient.InfluxDBError> {
        Future<Data, InfluxDBClient.InfluxDBError> { promise in
            self.queryRaw(query: query, org: org, dialect: dialect, responseQueue: responseQueue) { result -> Void in
                switch result {
                case let .success(data):
                    promise(.success(data))
                case let .failure(error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    #endif

    private func postQuery(_ query: String,
                           _ org: String?,
                           _ dialect: Dialect = defaultDialect,
                           _ responseQueue: DispatchQueue,
                           _ completion: @escaping (
                                   _ result: Swift.Result<Data, InfluxDBClient.InfluxDBError>) -> Void) {
        do {
            guard let org = org ?? client.options.org else {
                throw InfluxDBClient.InfluxDBError
                        .generic("The organization executing the query  should be specified.")
            }

            var components = URLComponents(string: client.url + "/api/v2/query")
            components?.queryItems = [
                URLQueryItem(name: "org", value: org)
            ]

            // Body
            let body = try CodableHelper.encode(Query(query: query, dialect: dialect)).get()

            client.httpPost(
                    components,
                    "application/json; charset=utf-8",
                    "text/csv",
                    InfluxDBClient.GZIPMode.response,
                    body,
                    responseQueue) { result -> Void in
                switch result {
                case let .success(data):
                    completion(.success(data ?? Data(count: 0)))
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
}
