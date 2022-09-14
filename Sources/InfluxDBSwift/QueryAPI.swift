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

/// The asynchronous API to Query InfluxDB 2.x.
///
/// ### Example: ###
/// #### Query into sequence of `FluxRecord` ####
/// ````
/// let query = """
///             from(bucket: "my-bucket")
///                 |> range(start: -10m)
///                 |> filter(fn: (r) => r["_measurement"] == "cpu")
///                 |> filter(fn: (r) => r["cpu"] == "cpu-total")
///                 |> filter(fn: (r) => r["_field"] == "usage_user" or r["_field"] == "usage_system")
///                 |> last()
///             """
///
/// print("\nQuery to execute:\n\(query)\n")
///
/// let records = try await client.queryAPI.query(query: query)
///
/// print("Query results:")
/// try records.forEach { print(" > \($0.values["_field"]!): \($0.values["_value"]!)") }
/// ````
/// #### Query into `Data` ####
/// ````
/// client.queryAPI.queryRaw(query: query) { response, error in
///     // For handle error
///     if let error = error {
///         print("Error:\n\n\(error)")
///     }
///
///     // For Success response
///     if let response = response {
///         let csv = String(decoding: response, as: UTF8.self)
///         print("InfluxDB response: \(csv)")
///     }
/// }
/// ````
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
    init(client: InfluxDBClient) {
        self.client = client
    }

    /// Query executes a query and returns the response as a `Cursor<FluxRecord>`.
    ///
    /// - Parameters:
    ///   - query: The Flux query to execute.
    ///   - org: The organization executing the query. Takes either the `ID` or `Name` interchangeably.
    ///   - params: params represent key/value pairs parameters to be injected into query
    ///   - responseQueue: The queue on which api response is dispatched.
    ///   - completion: The handler to receive the data and the error objects.
    public func query(query: String,
                      org: String? = nil,
                      params: [String: String]? = nil,
                      responseQueue: DispatchQueue = .main,
                      completion: @escaping (_ response: FluxRecordCursor?,
                                             _ error: InfluxDBClient.InfluxDBError?) -> Void) {
        self.query(query: query, org: org, params: params, responseQueue: responseQueue) { result -> Void in
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
    ///   - params: params represent key/value pairs parameters to be injected into query
    ///   - responseQueue: The queue on which api response is dispatched.
    ///   - completion: completion handler to receive the `Swift.Result`
    public func query(query: String,
                      org: String? = nil,
                      params: [String: String]? = nil,
                      responseQueue: DispatchQueue = .main,
                      completion: @escaping (
                              _ result: Swift.Result<FluxRecordCursor, InfluxDBClient.InfluxDBError>) -> Void) {
        self.queryRaw(
                query: query,
                org: org,
                dialect: QueryAPI.defaultDialect,
                params: params,
                responseQueue: responseQueue) { result -> Void in
            switch result {
            case let .success(data):
                do {
                    try completion(.success(FluxRecordCursor(data: data)))
                } catch {
                    completion(.failure(InfluxDBClient.InfluxDBError.cause(error)))
                }
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
    ///   - params: params represent key/value pairs parameters to be injected into query
    ///   - responseQueue: The queue on which api response is dispatched.
    /// - Returns: Publisher to attach a subscriber
    @available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public func query(query: String,
                      org: String? = nil,
                      params: [String: String]? = nil,
                      responseQueue: DispatchQueue = .main)
                    -> AnyPublisher<FluxRecordCursor, InfluxDBClient.InfluxDBError> {
        Future<FluxRecordCursor, InfluxDBClient.InfluxDBError> { promise in
            self.query(query: query, org: org, params: params, responseQueue: responseQueue) { result -> Void in
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

    #if swift(>=5.5)
    /// Query executes a query and asynchronously returns the response as a `Cursor<FluxRecord>`.
    ///
    /// - Parameters:
    ///   - query: The Flux query to execute.
    ///   - org: The organization executing the query. Takes either the `ID` or `Name` interchangeably.
    ///   - params: params represent key/value pairs parameters to be injected into query
    ///   - responseQueue: The queue on which api response is dispatched.
    /// - Returns: `Cursor<FluxRecord>`
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func query(query: String,
                      org: String? = nil,
                      params: [String: String]? = nil,
                      responseQueue: DispatchQueue = .main) async throws -> FluxRecordCursor {
        try await withCheckedThrowingContinuation { continuation in
            self.query(query: query, org: org, params: params, responseQueue: responseQueue) { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    #endif

    /// QueryRaw executes a query and returns the response as a `Data`.
    ///
    /// - Parameters:
    ///   - query: The Flux query to execute.
    ///   - org: The organization executing the query. Takes either the `ID` or `Name` interchangeably.
    ///   - dialect: The Dialect are options to change the default CSV output format.
    ///   - params: params represent key/value pairs parameters to be injected into query
    ///   - responseQueue: The queue on which api response is dispatched.
    ///   - completion: handler to receive the data and the error objects
    public func queryRaw(query: String,
                         org: String? = nil,
                         dialect: Dialect = defaultDialect,
                         params: [String: String]? = nil,
                         responseQueue: DispatchQueue = .main,
                         completion: @escaping (_ response: Data?, _ error: InfluxDBClient.InfluxDBError?) -> Void) {
        self.queryRaw(query: query,
                      org: org,
                      dialect: dialect,
                      params: params,
                      responseQueue: responseQueue) { result -> Void in
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
    ///   - params: params represent key/value pairs parameters to be injected into query
    ///   - responseQueue: The queue on which api response is dispatched.
    ///   - completion: completion handler to receive the `Swift.Result`
    public func queryRaw(query: String,
                         org: String? = nil,
                         dialect: Dialect = defaultDialect,
                         params: [String: String]? = nil,
                         responseQueue: DispatchQueue = .main,
                         completion: @escaping (_ result: Swift.Result<Data, InfluxDBClient.InfluxDBError>) -> Void) {
        guard let org = org ?? client.options.org else {
            responseQueue.async {
                let error = InfluxDBClient.InfluxDBError.generic(
                        "The organization executing the query should be specified.")
                return completion(.failure(error))
            }
            return
        }

        let model = Query(query: query, params: params, dialect: dialect)
        var url = URLComponents(string: client.url + "/api/v2/query")
        url?.queryItems = [
            URLQueryItem(name: "org", value: org)
        ]
        client.queryRequest(model, url, InfluxDBClient.GZIPMode.response, responseQueue, completion)
    }

    #if canImport(Combine)
    /// QueryRaw executes a query and returns the response as a `Data`.
    ///
    /// - Parameters:
    ///   - query: The Flux query to execute.
    ///   - org: The organization executing the query. Takes either the `ID` or `Name` interchangeably.
    ///   - dialect: The Dialect are options to change the default CSV output format.
    ///   - params: params represent key/value pairs parameters to be injected into query
    ///   - responseQueue: The queue on which api response is dispatched.
    /// - Returns: Publisher to attach a subscriber
    @available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public func queryRaw(query: String,
                         org: String? = nil,
                         dialect: Dialect = defaultDialect,
                         params: [String: String]? = nil,
                         responseQueue: DispatchQueue = .main) -> AnyPublisher<Data, InfluxDBClient.InfluxDBError> {
        Future<Data, InfluxDBClient.InfluxDBError> { promise in
            self.queryRaw(query: query,
                          org: org,
                          dialect: dialect,
                          params: params,
                          responseQueue: responseQueue) { result -> Void in
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

    #if swift(>=5.5)
    /// QueryRaw executes a query and asynchronously returns the response as a `Data`.
    ///
    /// - Parameters:
    ///   - query: The Flux query to execute.
    ///   - org: The organization executing the query. Takes either the `ID` or `Name` interchangeably.
    ///   - params: params represent key/value pairs parameters to be injected into query
    ///   - responseQueue: The queue on which api response is dispatched.
    /// - Returns: `Cursor<FluxRecord>`
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func queryRaw(query: String,
                         org: String? = nil,
                         params: [String: String]? = nil,
                         responseQueue: DispatchQueue = .main) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            self.queryRaw(query: query, org: org, params: params, responseQueue: responseQueue) { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
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
        public var group = false
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
    public class FluxRecord: Equatable {
        /// The list of values in Record
        public let values: [String: Decodable]

        /// Initialize records with values.
        ///
        /// - Parameter values: record values
        public init(values: [String: Decodable]) {
            self.values = values
        }

        public static func == (lhs: FluxRecord, rhs: FluxRecord) -> Bool {
            NSDictionary(dictionary: lhs.values).isEqual(rhs.values)
        }
    }
}

extension QueryAPI {
    /// Cursor for `FluxRecord`.
    public final class FluxRecordCursor: Cursor {
        private let _parser: FluxCSVParser

        init(data: Data, responseMode: FluxCSVParser.ResponseMode = .full) throws {
            _parser = try FluxCSVParser(data: data, responseMode: responseMode)
        }

        /// Get next element and returns it, or nil if no next element exists.
        public func next() throws -> FluxRecord? {
            try _parser.next()?.record
        }
    }
}
