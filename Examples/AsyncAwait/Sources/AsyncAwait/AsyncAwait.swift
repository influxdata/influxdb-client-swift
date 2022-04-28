//
// Created by Jakub Bednář on 04/22/2022.
//

import ArgumentParser
import Foundation
import InfluxDBSwift
import InfluxDBSwiftApis

@main
struct AsyncAwait: AsyncParsableCommand {
    @Option(name: .shortAndLong, help: "The name or id of the bucket destination.")
    private var bucket: String

    @Option(name: .shortAndLong, help: "The name or id of the organization destination.")
    private var org: String

    @Option(name: .shortAndLong, help: "Authentication token.")
    private var token: String

    @Option(name: .shortAndLong, help: "HTTP address of InfluxDB.")
    private var url: String
}

extension AsyncAwait {
    mutating func run() async throws {
        //
        // Initialize Client with default Bucket and Organization
        //
        let client = InfluxDBClient(
                url: url,
                token: token,
                options: InfluxDBClient.InfluxDBOptions(bucket: self.bucket, org: self.org))

        //
        // Asynchronous write
        //
        let point = InfluxDBClient
                .Point("demo")
                .addTag(key: "type", value: "point")
                .addField(key: "value", value: .int(2))
        try await client.makeWriteAPI().write(point: point)
        print("Written data:\n > \(try point.toLineProtocol())")

        //
        // Asynchronous query
        //
        let query = """
                    from(bucket: "\(self.bucket)")
                        |> range(start: -10m)
                        |> filter(fn: (r) => r["_measurement"] == "demo")
                    """
        let records = try await client.queryAPI.query(query: query)
        print("Query results:")
        try records.forEach { print(" > \($0.values["_field"]!): \($0.values["_value"]!)") }

        //
        // List all Buckets
        //
        let api = InfluxDB2API(client: client)
        let buckets = try await api.bucketsAPI.getBuckets()
        print("Buckets:")
        buckets?.buckets?.forEach { print(" > \($0.id): \($0.name)") }

        client.close()
    }
}
