//
// Warning: Parameterized Queries are supported only in InfluxDB Cloud, currently there is no support in InfluxDB OSS.
//

import ArgumentParser
import Foundation
import InfluxDBSwift

struct ParameterizedQuery: ParsableCommand {
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
                    from(bucket: params.bucketParam)
                        |> range(start: duration(v: params.startParam))
                        |> filter(fn: (r) => r["_measurement"] == "cpu")
                        |> filter(fn: (r) => r["cpu"] == "cpu-total")
                        |> filter(fn: (r) => r["_field"] == "usage_user" or r["_field"] == "usage_system")
                        |> last()
                    """
        // Query parameters [String:String]
        let queryParams = [ "bucketParam":"\(self.bucket)", "startParam":"-10m" ]

        print("\nQuery to execute:\n\n\(query)\n\n\(queryParams)")

        client.queryAPI.query(query: query, params: queryParams) { response, error in
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

ParameterizedQuery.main()
