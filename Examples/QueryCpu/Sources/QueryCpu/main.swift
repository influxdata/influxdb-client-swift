//
// Created by Jakub Bednář on 05/11/2020.
//

import ArgumentParser
import Foundation
import InfluxDBSwift

struct QueryCpu: ParsableCommand {
    @Option(name: .shortAndLong, help: "The bucket to query. The name or id of the bucket destination.")
    private var bucket: String

    @Option(name: .shortAndLong,
            help: "The organization executing the query. Takes either the `ID` or `Name` interchangeably.")
    private var org: String

    @Option(name: .shortAndLong, help: "Authentication token.")
    private var token: String

    @Option(name: .shortAndLong, help: "HTTP address of InfluxDB.")
    private var url: String

    public func run() {
        // Initialize Client with default Organization
        let client = InfluxDBClient(
                url: url,
                token: token,
                options: InfluxDBClient.InfluxDBOptions(org: self.org))

        // Flux query
        let query = """
                    from(bucket: "\(self.bucket)")
                        |> range(start: -10m)
                        |> filter(fn: (r) => r["_measurement"] == "cpu")
                        |> filter(fn: (r) => r["cpu"] == "cpu-total")
                        |> filter(fn: (r) => r["_field"] == "usage_user" or r["_field"] == "usage_system")
                        |> last()
                    """

        print("\nQuery to execute:\n\n\(query)")

        client.queryAPI.query(query: query) { response, error in
            // For handle error
            if let error = error {
                self.atExit(client: client, error: error)
            }

            // For Success response
            if let response = response {
                print("\nSuccess response...\n")
                print("CPU usage:")
                do {
                    try response.forEach { record in
                        print("\t\(record.values["_field"]!): \(record.values["_value"]!)")
                    }
                } catch {
                    self.atExit(client: client, error: InfluxDBClient.InfluxDBError.cause(error))
                }
            }

            self.atExit(client: client)
        }

        // Wait to end of script
        RunLoop.current.run()
    }

    private func atExit(client: InfluxDBClient, error: InfluxDBClient.InfluxDBError? = nil) {
        // Dispose the Client
        client.close()
        // Exit script
        Self.exit(withError: error)
    }
}

QueryCpu.main()
