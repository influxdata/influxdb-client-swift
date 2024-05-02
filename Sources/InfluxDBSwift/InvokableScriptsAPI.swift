//
// Created by Jakub Bednář on 01.04.2022.
//

import Foundation

/// Use API invokable scripts to create custom InfluxDB API endpoints that query, process, and shape data.
///
/// API invokable scripts let you assign scripts to API endpoints and then execute them
/// as standard REST operations in InfluxDB Cloud.
public struct InvokableScriptsAPI: Sendable {
    /// Shared client.
    private let client: InfluxDBClient

    /// Create a new InvokableScriptsApi for InfluxDB
    ///
    /// - Parameters
    ///    - client: Client with shared configuration and http library.
    init(client: InfluxDBClient) {
        self.client = client
    }

    /// Create a script.
    ///
    /// - Parameters:
    ///   - createRequest: The script to create.
    ///   - responseQueue: The queue on which api response is dispatched.
    ///   - completion: completion handler to receive the created Script or the error object
    public func createScript(createRequest: ScriptCreateRequest,
                             responseQueue: DispatchQueue = .main,
                             completion: @escaping (
                                     _ result: Swift.Result<Script?, InfluxDBClient.InfluxDBError>) -> Void) {
        httpRequest(model: createRequest, responseQueue: responseQueue, completion: completion)
    }

    #if swift(>=5.5)
    /// Create a script.
    ///
    /// - Parameters:
    ///   - createRequest: The script to create.
    ///   - responseQueue: The queue on which api response is dispatched.
    /// - Returns: `Script`
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func createScript(createRequest: ScriptCreateRequest,
                             responseQueue: DispatchQueue = .main) async throws -> Script? {
        try await withCheckedThrowingContinuation { continuation in
            self.createScript(createRequest: createRequest, responseQueue: responseQueue) { result in
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

    /// Update a script.
    ///
    /// - Parameters:
    ///   - scriptId: The ID of the script to update. (required)
    ///   - updateRequest: Script updates to apply (required)
    ///   - responseQueue: The queue on which api response is dispatched.
    ///   - completion: completion handler to receive the updated Script or the error object
    public func updateScript(scriptId: String,
                             updateRequest: ScriptUpdateRequest,
                             responseQueue: DispatchQueue = .main,
                             completion: @escaping (
                                     _ result: Swift.Result<Script?, InfluxDBClient.InfluxDBError>) -> Void) {
        httpRequest(
                queryId: scriptId,
                model: updateRequest,
                httpMethod: "PATCH",
                responseQueue: responseQueue,
                completion: completion)
    }

    #if swift(>=5.5)
    /// Update a script.
    ///
    /// - Parameters:
    ///   - scriptId: The ID of the script to update. (required)
    ///   - updateRequest: Script updates to apply (required)
    ///   - responseQueue: The queue on which api response is dispatched.
    /// - Returns: `Script`
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func updateScript(scriptId: String,
                             updateRequest: ScriptUpdateRequest,
                             responseQueue: DispatchQueue = .main) async throws -> Script? {
        try await withCheckedThrowingContinuation { continuation in
            self.updateScript(
                    scriptId: scriptId,
                    updateRequest: updateRequest,
                    responseQueue: responseQueue) { result in
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

    /// List scripts
    ///
    /// - Parameters:
    ///   - limit: (query) The number of scripts to return. (optional)
    ///   - offset: (query) The offset for pagination. (optional)
    ///   - responseQueue: The queue on which api response is dispatched.
    ///   - completion: completion handler to receive the list of Scripts or the error object
    public func findScripts(limit: Int? = nil,
                            offset: Int? = nil,
                            responseQueue: DispatchQueue = .main,
                            completion: @escaping (
                                    _ result: Swift.Result<Scripts?, InfluxDBClient.InfluxDBError>) -> Void) {
        let queryItems = APIHelper.mapValuesToQueryItems([
            "limit": limit,
            "offset": offset
        ])

        httpRequest(
                queryItems: queryItems,
                model: nil as String?,
                httpMethod: "GET",
                responseQueue: responseQueue,
                completion: completion)
    }

    #if swift(>=5.5)
    /// List scripts
    ///
    /// - Parameters:
    ///   - limit: (query) The number of scripts to return. (optional)
    ///   - offset: (query) The offset for pagination. (optional)
    ///   - responseQueue: The queue on which api response is dispatched.
    /// - Returns: `Scripts`
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func findScripts(limit: Int? = nil,
                            offset: Int? = nil,
                            responseQueue: DispatchQueue = .main) async throws -> Scripts? {
        try await withCheckedThrowingContinuation { continuation in
            self.findScripts(
                    limit: limit,
                    offset: offset,
                    responseQueue: responseQueue) { result in
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

    ///  Delete a script
    ///
    /// - Parameters:
    ///   - scriptId: The ID of the script to delete. (required)
    ///   - responseQueue: The queue on which api response is dispatched.
    ///   - completion: completion handler to receive the list of Scripts or the error object
    public func deleteScript(scriptId: String,
                             responseQueue: DispatchQueue = .main,
                             completion: @escaping (
                                     _ result: Swift.Result<Void, InfluxDBClient.InfluxDBError>) -> Void) {
        httpRequest(
                queryId: scriptId,
                model: nil as String?,
                httpMethod: "DELETE",
                responseQueue: responseQueue) { (result: Result<String?, InfluxDBClient.InfluxDBError>) in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    #if swift(>=5.5)
    ///  Delete a script
    ///
    /// - Parameters:
    ///   - scriptId: The ID of the script to delete. (required)
    ///   - responseQueue: The queue on which api response is dispatched.
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func deleteScript(scriptId: String,
                             responseQueue: DispatchQueue = .main) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) -> Void in
            self.deleteScript(scriptId: scriptId, responseQueue: responseQueue) { result in
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

    /// Invoke asynchronously a script and return result as a `Cursor<FluxRecord>`.
    ///
    /// - Parameters:
    ///   - scriptId: The ID of the script to invoke. (required)
    ///   - params: params represent key/value pairs parameters to be injected into script
    ///   - responseQueue: The queue on which api response is dispatched.
    ///   - completion: completion handler to receive the `Swift.Result`
    public func invokeScript(scriptId: String,
                             params: [String: String]? = nil,
                             responseQueue: DispatchQueue = .main,
                             completion: @escaping (
                                     _ result: Swift.Result<QueryAPI.FluxRecordCursor, InfluxDBClient.InfluxDBError>)
                             -> Void) {
        let model = ScriptInvocationParams(params: params)
        let url = urlComponents(scriptId: scriptId, resource: "invoke")
        client.queryRequest(model, url, InfluxDBClient.GZIPMode.none, responseQueue) { result -> Void in
            switch result {
            case let .success(data):
                do {
                    try completion(.success(QueryAPI.FluxRecordCursor(data: data, responseMode: .onlyNames)))
                } catch {
                    completion(.failure(InfluxDBClient.InfluxDBError.cause(error)))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    #if swift(>=5.5)
    /// Invoke asynchronously a script and return result as a `Cursor<FluxRecord>`.
    ///
    /// - Parameters:
    ///   - scriptId: The ID of the script to invoke. (required)
    ///   - params: params represent key/value pairs parameters to be injected into script
    ///   - responseQueue: The queue on which api response is dispatched.
    /// - Returns: `Cursor<FluxRecord>`
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func invokeScript(scriptId: String,
                             params: [String: String]? = nil,
                             responseQueue: DispatchQueue = .main) async throws -> QueryAPI.FluxRecordCursor {
        try await withCheckedThrowingContinuation { continuation in
            self.invokeScript(scriptId: scriptId, params: params, responseQueue: responseQueue) { result in
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

    /// Invoke asynchronously a script and return result as a `Data`.
    ///
    /// - Parameters:
    ///   - scriptId: The ID of the script to invoke. (required)
    ///   - params: params represent key/value pairs parameters to be injected into script
    ///   - responseQueue: The queue on which api response is dispatched.
    ///   - completion: completion handler to receive the `Swift.Result`
    public func invokeScriptRaw(scriptId: String,
                                params: [String: String]? = nil,
                                responseQueue: DispatchQueue = .main,
                                completion: @escaping (
                                        _ result: Swift.Result<Data, InfluxDBClient.InfluxDBError>) -> Void) {
        let model = ScriptInvocationParams(params: params)
        let url = urlComponents(scriptId: scriptId, resource: "invoke")
        client.queryRequest(model, url, InfluxDBClient.GZIPMode.none, responseQueue, completion)
    }

    #if swift(>=5.5)
    /// Invoke asynchronously a script and return result as a `Data`.
    ///
    /// - Parameters:
    ///   - scriptId: The ID of the script to invoke. (required)
    ///   - params: params represent key/value pairs parameters to be injected into script
    ///   - responseQueue: The queue on which api response is dispatched.
    /// - Returns: `Data`
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func invokeScriptRaw(scriptId: String,
                                params: [String: String]? = nil,
                                responseQueue: DispatchQueue = .main) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            self.invokeScriptRaw(scriptId: scriptId, params: params, responseQueue: responseQueue) { result in
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

    private func httpRequest<M, B>(queryId: String? = nil,
                                   queryItems: [URLQueryItem]? = nil,
                                   model: M? = nil,
                                   httpMethod: String = "POST",
                                   responseQueue: DispatchQueue,
                                   completion: @escaping (Result<B?, InfluxDBClient.InfluxDBError>) -> Void)
            where M: Encodable, B: Decodable {
        var url = urlComponents(scriptId: queryId)
        url?.queryItems = queryItems

        do {
            var body: Data?
            if let model = model {
                body = try CodableHelper.encode(model).get()
            }
            client.httpRequest(
                    url,
                    "application/json; charset=utf-8",
                    "application/json",
                    InfluxDBClient.GZIPMode.none,
                    body,
                    httpMethod,
                    responseQueue) { result -> Void in
                switch result {
                case let .success(success):
                    do {
                        if let data = success {
                            if data.isEmpty {
                                completion(.success(nil))
                            } else {
                                let model = try CodableHelper.decode(B.self, from: data).get()
                                completion(.success(model))
                            }
                        }
                    } catch {
                        completion(.failure(InfluxDBClient.InfluxDBError.cause(error)))
                    }
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

    private func urlComponents(scriptId: String? = nil, resource: String? = nil) -> URLComponents? {
        let urls = [
            client.url,
            "api/v2/scripts",
            scriptId?.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
            resource
        ].compactMap {
                    $0
        }
                .joined(separator: "/")

        return URLComponents(string: urls)
    }
}
