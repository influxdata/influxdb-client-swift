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
import SwiftCSV

/// The asynchronous API to Query InfluxDB 2.0.
public class QueryAPI {
    /// Shared client.
    private let client: InfluxDBClient

    /// Create a new QueryAPI for a InfluxDB.
    ///
    /// - Parameters
    ///   - client: Client with shared configuration and http library.
    public init(client: InfluxDBClient) {
        self.client = client
    }
}
