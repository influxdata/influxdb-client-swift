//
// Created by Jakub Bednář on 01.04.2022.
//

import Foundation

/// Use API invokable scripts to create custom InfluxDB API endpoints that query, process, and shape data.
///
/// API invokable scripts let you assign scripts to API endpoints and then execute them
/// as standard REST operations in InfluxDB Cloud.
public class InvocableScriptsAPI {
    /// Shared client.
    private let client: InfluxDBClient

    /// Create a new InvocableScriptsApi for InfluxDB
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
                                     _ result: Swift.Result<Script, InfluxDBClient.InfluxDBError>) -> Void) {
        do {
            let components = URLComponents(string: client.url + "/api/v2/scripts")
            let body = try CodableHelper.encode(createRequest).get()

            client.httpPost(
                    components,
                    "application/json; charset=utf-8",
                    "application/json",
                    InfluxDBClient.GZIPMode.none,
                    body,
                    responseQueue) { result -> Void in
                switch result {
                case let .success(success):
                    let model = try! CodableHelper.decode(Script.self, from: success!).get()
                    completion(.success(model))
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
