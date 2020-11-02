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
/// api.getHealthAPI().getHealth { (response, error) in
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
public class InfluxDB2API {
    internal let client: InfluxDBClient
    internal let basePath: String
    internal let requestBuilderFactory: RequestBuilderFactory
    internal let apiResponseQueue: DispatchQueue

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

    /// Get shared `URLSession`.
    ///
    /// - Returns: shared `URLSession`
    internal func getURLSession() -> URLSession {
        client.session
    }
}

extension InfluxDB2API {
    /// Create a new instance of `AuthorizationsAPI`.
    ///
    /// - Returns: AuthorizationsAPI
    public func getAuthorizationsAPI() -> InfluxDB2API.AuthorizationsAPI {
        AuthorizationsAPI(influxDB2API: self)
    }

    /// Create a new instance of `BucketsAPI`.
    ///
    /// - Returns: BucketsAPI
    public func getBucketsAPI() -> InfluxDB2API.BucketsAPI {
        BucketsAPI(influxDB2API: self)
    }

    /// Create a new instance of `DBRPsAPI`.
    ///
    /// - Returns: DBRPsAPI
    public func getDBRPsAPI() -> InfluxDB2API.DBRPsAPI {
        DBRPsAPI(influxDB2API: self)
    }

    /// Create a new instance of `HealthAPI`.
    ///
    /// - Returns: HealthAPI
    public func getHealthAPI() -> InfluxDB2API.HealthAPI {
        HealthAPI(influxDB2API: self)
    }

    /// Create a new instance of `LabelsAPI`.
    ///
    /// - Returns: LabelsAPI
    public func getLabelsAPI() -> InfluxDB2API.LabelsAPI {
        LabelsAPI(influxDB2API: self)
    }

    /// Create a new instance of `OrganizationsAPI`.
    ///
    /// - Returns: OrganizationsAPI
    public func getOrganizationsAPI() -> InfluxDB2API.OrganizationsAPI {
        OrganizationsAPI(influxDB2API: self)
    }

    /// Create a new instance of `ReadyAPI`.
    ///
    /// - Returns: ReadyAPI
    public func getReadyAPI() -> InfluxDB2API.ReadyAPI {
        ReadyAPI(influxDB2API: self)
    }

    /// Create a new instance of `ScraperTargetsAPI`.
    ///
    /// - Returns: ScraperTargetsAPI
    public func getScraperTargetsAPI() -> InfluxDB2API.ScraperTargetsAPI {
        ScraperTargetsAPI(influxDB2API: self)
    }

    /// Create a new instance of `SecretsAPI`.
    ///
    /// - Returns: SecretsAPI
    public func getSecretsAPI() -> InfluxDB2API.SecretsAPI {
        SecretsAPI(influxDB2API: self)
    }

    /// Create a new instance of `SetupAPI`.
    ///
    /// - Returns: SetupAPI
    public func getSetupAPI() -> InfluxDB2API.SetupAPI {
        SetupAPI(influxDB2API: self)
    }

    /// Create a new instance of `SourcesAPI`.
    ///
    /// - Returns: SourcesAPI
    public func getSourcesAPI() -> InfluxDB2API.SourcesAPI {
        SourcesAPI(influxDB2API: self)
    }

    /// Create a new instance of `TasksAPI`.
    ///
    /// - Returns: TasksAPI
    public func getTasksAPI() -> InfluxDB2API.TasksAPI {
        TasksAPI(influxDB2API: self)
    }

    /// Create a new instance of `UsersAPI`.
    ///
    /// - Returns: UsersAPI
    public func getUsersAPI() -> InfluxDB2API.UsersAPI {
        UsersAPI(influxDB2API: self)
    }

    /// Create a new instance of `VariablesAPI`.
    ///
    /// - Returns: VariablesAPI
    public func getVariablesAPI() -> InfluxDB2API.VariablesAPI {
        VariablesAPI(influxDB2API: self)
    }
}
