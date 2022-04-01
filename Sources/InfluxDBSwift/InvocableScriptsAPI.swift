//
// Created by Jakub Bednář on 01.04.2022.
//

import Foundation

/// Use API invokable scripts to create custom InfluxDB API endpoints that query, process, and shape data.
///
/// API invokable scripts let you assign scripts to API endpoints and then execute them as standard REST operations in InfluxDB Cloud.
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
}
