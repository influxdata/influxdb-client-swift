//
// Created by Jakub Bednář on 05/11/2020.
//

import Foundation

/// The API to Write time-series data into InfluxDB 2.0.
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
}
