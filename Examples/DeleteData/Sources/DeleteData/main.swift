//
// Created by Jakub Bednář on 05/11/2020.
//

import ArgumentParser
import Foundation
import InfluxDBSwift

struct DeleteData: ParsableCommand {
    @Option(name: .shortAndLong, help: "Specifies the bucket name to delete data from.")
    private var bucket: String

    @Option(name: .shortAndLong,
            help: "Specifies the organization name to delete data from.")
    private var org: String

    @Option(name: .shortAndLong, help: "Authentication token.")
    private var token: String

    @Option(name: .shortAndLong, help: "HTTP address of InfluxDB.")
    private var url: String

    @Option(name: .shortAndLong, help: "InfluxQL-like delete predicate statement.")
    private var predicate: String

    public func run() {
        // Initialize Client with default Organization
        let client = InfluxDBClient(
                url: url,
                token: token,
                options: InfluxDBClient.InfluxDBOptions(org: self.org))

        // Create DeletePredicateRequest
        let predicateRequest = DeletePredicateRequest(
                start: Date(timeIntervalSince1970: 0),
                stop: Date(),
                predicate: predicate)

        client.deleteAPI.delete(predicate: predicateRequest, bucket: bucket, org: org) { result, error in
            // For handle error
            if let error = error {
                self.atExit(client: client, error: error)
            }

            // For Success Delete
            if result != nil {
                print("\nDeleted data by predicate:\n\n\t\(predicateRequest)")

                // Print date after Delete
                queryData(client: client)
            }
        }

        // Wait to end of script
        RunLoop.current.run()
    }

    private func queryData(client: InfluxDBClient) {
        let query = """
                    from(bucket: "\(self.bucket)")
                        |> range(start: 0)
                        |> filter(fn: (r) => r["_measurement"] == "server")
                        |> pivot(rowKey:["_time"], columnKey: ["_field"], valueColumn: "_value")
                    """

        client.queryAPI.query(query: query) { response, error in
            // For handle error
            if let error = error {
                self.atExit(client: client, error: error)
            }

            // For Success response
            if let response = response {
                print("\nRemaining data after delete:\n")
                do {
                    try response.forEach { record in
                        let provider = record.values["provider"]!
                        let production = record.values["production"]
                        let app = record.values["app"]
                        return print("\t\(provider),production=\(production!),app=\(app!)")
                    }
                } catch {
                    self.atExit(client: client, error: InfluxDBClient.InfluxDBError.cause(error))
                }
            }

            self.atExit(client: client)
        }
    }

    private func atExit(client: InfluxDBClient, error: InfluxDBClient.InfluxDBError? = nil) {
        // Dispose the Client
        client.close()
        // Exit script
        Self.exit(withError: error)
    }
}

DeleteData.main()
