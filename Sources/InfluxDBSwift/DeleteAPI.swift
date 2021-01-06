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

/// Delete time series data from InfluxDB 2.0.
///
/// ### Example: ###
/// ````
/// ````
public class DeleteAPI {
    /// Shared client.
    private let client: InfluxDBClient

    /// Create a new DeleteAPI for InfluxDB
    ///
    /// - Parameters
    ///    - client: Client with shared configuration and http library.
    public init(client: InfluxDBClient) {
        self.client = client
    }

}
