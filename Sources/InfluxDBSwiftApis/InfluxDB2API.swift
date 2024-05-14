//
// Created by Jakub Bednář on 29/10/2020.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import InfluxDBSwift

/// InfluxDB2API providing a support for managements APIs.
///
/// ### Example: ###
/// ````
/// let client = InfluxDBClient(url: "http://localhost:8086", token: "my-token")
/// let api = InfluxDB2API(client: client)
///
/// api.healthAPI.getHealth { (response, error) in
///    if let error = error {
///        print(error)
///        return
///    }
///
///    if let response = response {
///        dump(response)
///    }
/// }
///
/// client.close()
/// ````
public struct InfluxDB2API {
    internal let client: InfluxDBClient
    internal let basePath: String
    internal let requestBuilderFactory: RequestBuilderFactory
    internal let apiResponseQueue: DispatchQueue
    /// Shared `URLSession`.
    internal var urlSession: URLSession {
        client.session
    }

    /// Lazy initialized `AuthorizationsAPI`.
    public var authorizationsAPI: AuthorizationsAPI { AuthorizationsAPI(influxDB2API: self) }

    /// Lazy initialized `BucketsAPI`.
    public var bucketsAPI: BucketsAPI { BucketsAPI(influxDB2API: self) }

    /// Lazy initialized `DBRPsAPI`.
    public var dbrpsAPI: DBRPsAPI { DBRPsAPI(influxDB2API: self) }

    /// Lazy initialized `HealthAPI`.
    public var healthAPI: HealthAPI { HealthAPI(influxDB2API: self) }

    /// Lazy initialized `PingAPI`.
    public var pingAPI: PingAPI { PingAPI(influxDB2API: self) }

    /// Lazy initialized `LabelsAPI`.
    public var labelsAPI: LabelsAPI { LabelsAPI(influxDB2API: self) }

    /// Lazy initialized `OrganizationsAPI`.
    public var organizationsAPI: OrganizationsAPI { OrganizationsAPI(influxDB2API: self) }

    /// Lazy initialized `ReadyAPI`.
    public var readyAPI: ReadyAPI { ReadyAPI(influxDB2API: self) }

    /// Lazy initialized `ScraperTargetsAPI`.
    public var scraperTargetsAPI: ScraperTargetsAPI { ScraperTargetsAPI(influxDB2API: self) }

    /// Lazy initialized `SecretsAPI`.
    public var secretsAPI: SecretsAPI { SecretsAPI(influxDB2API: self) }

    /// Lazy initialized `SetupAPI`.
    public var setupAPI: SetupAPI { SetupAPI(influxDB2API: self) }

    /// Lazy initialized `SourcesAPI`.
    public var sourcesAPI: SourcesAPI { SourcesAPI(influxDB2API: self) }

    /// Lazy initialized `TasksAPI`.
    public var tasksAPI: TasksAPI { TasksAPI(influxDB2API: self) }

    /// Lazy initialized `UsersAPI`.
    public var usersAPI: UsersAPI { UsersAPI(influxDB2API: self) }

    /// Lazy initialized `VariablesAPI`.
    public var variablesAPI: VariablesAPI { VariablesAPI(influxDB2API: self) }

    /// Create a new managements client for a InfluxDB.
    ///
    /// - Parameters:
    ///   - client: the main InfluxDB client
    ///   - apiResponseQueue: The default queue on which api response is dispatched.
    public init(client: InfluxDBClient, apiResponseQueue: DispatchQueue = .main) {
        self.client = client
        self.basePath = client.url
        self.requestBuilderFactory = URLSessionRequestBuilderFactory()
        self.apiResponseQueue = apiResponseQueue
    }
}
