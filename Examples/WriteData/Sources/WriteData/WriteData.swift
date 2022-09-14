//
// Created by Jakub Bednář on 05/11/2020.
//

import ArgumentParser
import Foundation
import InfluxDBSwift
import InfluxDBSwiftApis

@main
struct WriteData: AsyncParsableCommand {
    @Option(name: .shortAndLong, help: "The name or id of the bucket destination.")
    private var bucket: String

    @Option(name: .shortAndLong, help: "The name or id of the organization destination.")
    private var org: String

    @Option(name: .shortAndLong, help: "Authentication token.")
    private var token: String

    @Option(name: .shortAndLong, help: "HTTP address of InfluxDB.")
    private var url: String
}

extension WriteData {
    mutating func run() async throws {
        //
        // Initialize Client with default Bucket and Organization
        //
        let client = InfluxDBClient(
                url: url,
                token: token,
                options: InfluxDBClient.InfluxDBOptions(bucket: bucket, org: org))

        //
        // Record defined as Data Point
        //
        let recordPoint = InfluxDBClient
                .Point("demo")
                .addTag(key: "type", value: "point")
                .addField(key: "value", value: .int(2))
        //
        // Record defined as Data Point with Timestamp
        //
        let recordPointDate = InfluxDBClient
                .Point("demo")
                .addTag(key: "type", value: "point-timestamp")
                .addField(key: "value", value: .int(2))
                .time(time: .date(Date()))

        try await client.makeWriteAPI().write(points: [recordPoint, recordPointDate])
        print("Written data:\n\n\([recordPoint, recordPointDate].map { "\t- \($0)" }.joined(separator: "\n"))")
        print("\nSuccess!")

        client.close()
    }
}
