//
// Created by Jakub Bednář on 05/11/2020.
//

import ArgumentParser
import Foundation
import InfluxDBSwift
import InfluxDBSwiftApis

@main
struct QueryCpu: AsyncParsableCommand {
    @Option(name: .shortAndLong, help: "The name or id of the bucket destination.")
    private var bucket: String

    @Option(name: .shortAndLong, help: "The name or id of the organization destination.")
    private var org: String

    @Option(name: .shortAndLong, help: "Authentication token.")
    private var token: String

    @Option(name: .shortAndLong, help: "HTTP address of InfluxDB.")
    private var url: String
}

extension QueryCpu {
    mutating func run() async throws {
        //
        // Initialize Client with default Bucket and Organization
        //
        let client = InfluxDBClient(
                url: url,
                token: token,
                options: InfluxDBClient.InfluxDBOptions(bucket: bucket, org: org))

        // Flux query
        let query = """
                    from(bucket: "\(self.bucket)")
                        |> range(start: -10m)
                        |> filter(fn: (r) => r["_measurement"] == "cpu")
                        |> filter(fn: (r) => r["cpu"] == "cpu-total")
                        |> filter(fn: (r) => r["_field"] == "usage_user" or r["_field"] == "usage_system")
                        |> last()
                    """

        print("\nQuery to execute:\n\(query)\n")

        let records = try await client.queryAPI.query(query: query)

        print("Query results:")
        try records.forEach { print(" > \($0.values["_field"]!): \($0.values["_value"]!)") }

        client.close()
    }
}
