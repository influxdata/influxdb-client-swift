//
// Warning: Parameterized Queries are supported only in InfluxDB Cloud, currently there is no support in InfluxDB OSS.
//

import ArgumentParser
import Foundation
import InfluxDBSwift
import InfluxDBSwiftApis

@main
struct ParameterizedQuery: AsyncParsableCommand {
    @Option(name: .shortAndLong, help: "The bucket to query. The name or id of the bucket destination.")
    private var bucket: String

    @Option(name: .shortAndLong,
            help: "The organization executing the query. Takes either the `ID` or `Name` interchangeably.")
    private var org: String

    @Option(name: .shortAndLong, help: "Authentication token.")
    private var token: String

    @Option(name: .shortAndLong, help: "HTTP address of InfluxDB.")
    private var url: String
}

extension ParameterizedQuery {
    mutating func run() async throws {
        // Initialize Client with default Organization
        let client = InfluxDBClient(
                url: url,
                token: token,
                options: InfluxDBClient.InfluxDBOptions(bucket: bucket, org: org))

        for i in 1...3 {
            let point = InfluxDBClient
                    .Point("demo")
                    .addTag(key: "type", value: "point")
                    .addField(key: "value", value: .int(i))
            try await client.makeWriteAPI().write(point: point)
        }

        // Flux query
        let query = """
                    from(bucket: params.bucketParam)
                        |> range(start: -10m)
                        |> filter(fn: (r) => r["_measurement"] == params.measurement)
                    """

        // Query parameters [String:String]
        let queryParams = [ "bucketParam":"\(bucket)", "measurement":"demo" ]

        print("\nQuery to execute:\n\n\(query)\n\n\(queryParams)")

        let records = try await client.queryAPI.query(query: query, params: queryParams)

        print("\nSuccess response...\n")

        try records.forEach { print(" > \($0.values["_field"]!): \($0.values["_value"]!)") }

        client.close()
    }
}