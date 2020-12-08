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

    /// Query executes a query and returns the response as a `Cursor<FluxRecord>`.
    ///
    /// - Parameters:
    ///   - query: The Flux query to execute.
    ///   - org: The organization executing the query. Takes either the `ID` or `Name` interchangeably.
    ///   - responseQueue: The queue on which api response is dispatched.
    ///   - completion: The handler to receive the data and the error objects.
    public func query(query: String,
                      org: String? = nil,
                      responseQueue: DispatchQueue = .main,
                      completion: @escaping (_ response: AnyCursor<FluxRecord>?,
                                             _ error: InfluxDBClient.InfluxDBError?) -> Void) {
        self.query(query: query, org: org, responseQueue: responseQueue) { result -> Void in
            switch result {
            case let .success(cursor):
                completion(cursor, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /// Query executes a query and returns the response as a `Cursor<FluxRecord>`.
    ///
    /// - Parameters:
    ///   - query: The Flux query to execute.
    ///   - org: The organization executing the query. Takes either the `ID` or `Name` interchangeably.
    ///   - responseQueue: The queue on which api response is dispatched.
    ///   - completion: completion handler to receive the `Swift.Result`
    public func query(query: String,
                      org: String? = nil,
                      responseQueue: DispatchQueue = .main,
                      completion: @escaping (
                              _ result: Swift.Result<AnyCursor<FluxRecord>, InfluxDBClient.InfluxDBError>) -> Void) {
        self.queryRaw(
                query: query,
                org: org,
                dialect: QueryAPI.defaultDialect,
                responseQueue: responseQueue) { result -> Void in
            switch result {
            case .success:
                completion(.success(AnyCursor([])))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    #if canImport(Combine)
    /// Query executes a query and returns the response as a `Cursor<FluxRecord>`.
    ///
    /// - Parameters:
    ///   - query: The Flux query to execute.
    ///   - org: The organization executing the query. Takes either the `ID` or `Name` interchangeably.
    ///   - responseQueue: The queue on which api response is dispatched.
    /// - Returns: Publisher to attach a subscriber
    @available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public func query(query: String,
                      org: String? = nil,
                      responseQueue: DispatchQueue = .main)
                    -> AnyPublisher<AnyCursor<FluxRecord>, InfluxDBClient.InfluxDBError> {
        Future<AnyCursor<FluxRecord>, InfluxDBClient.InfluxDBError> { promise in
            self.query(query: query, org: org, responseQueue: responseQueue) { result -> Void in
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
}

extension QueryAPI {
    /// FluxTable holds flux query result table information represented by collection of columns.
    public class FluxTable {
        /// The list of columns in Table.
        public var columns: [FluxColumn] = []
    }

    /// FluxColumn holds flux query table column properties
    public class FluxColumn {
        /// The index of column.
        public let index: Int
        /// The name of column.
        public var name: String = ""
        /// Description of the type of data contained within the column.
        public let dataType: String
        /// Boolean flag indicating if the column is part of the table's group key
        public var group: Bool = false
        /// Default value to be used for rows whose string value is the empty string.
        public var defaultValue: String = ""

        /// Initialize FluxColumn structure
        ///
        /// - Parameters:
        ///   - index: index in table
        ///   - dataType: type of column
        public init(index: Int, dataType: String) {
            self.index = index
            self.dataType = dataType
        }
    }

    /// FluxRecord represents row in the flux query result table
    public class FluxRecord {
        /// The list of values in Record
        public let values: [String: Any]

        /// Initialize records with values.
        ///
        /// - Parameter values: record values
        public init(values: [String: Any]) {
            self.values = values
        }
    }
}

extension QueryAPI {
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
