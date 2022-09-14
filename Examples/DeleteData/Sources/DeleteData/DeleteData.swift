//
// Created by Jakub Bednář on 05/11/2020.
//

import ArgumentParser
import Foundation
import InfluxDBSwift
import InfluxDBSwiftApis

@main
struct DeleteData: AsyncParsableCommand {
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
}

extension DeleteData {
    mutating func run() async throws {
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

        try await client.deleteAPI.delete(predicate: predicateRequest, bucket: bucket, org: org)

        print("\nDeleted data by predicate:\n\n\t\(predicateRequest)")

        // Print date after Delete
        try await queryData(client: client)

        client.close()
    }

    private func queryData(client: InfluxDBClient) async throws {
        let query = """
                    from(bucket: "\(bucket)")
                        |> range(start: 0)
                        |> filter(fn: (r) => r["_measurement"] == "server")
                        |> pivot(rowKey:["_time"], columnKey: ["_field"], valueColumn: "_value")
                    """

        let response = try await client.queryAPI.query(query: query)

        print("\nRemaining data after delete:\n")

        try response.forEach { record in
            let provider = record.values["provider"]!
            let production = record.values["production"]
            let app = record.values["app"]
            return print("\t\(provider),production=\(production!),app=\(app!)")
        }
    }
}
