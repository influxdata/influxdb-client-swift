//
// Created by Jakub Bednář on 10/13/2021.
//

import ArgumentParser
import Foundation
import InfluxDBSwift
import InfluxDBSwiftApis

@main
struct InfluxDBStatus: AsyncParsableCommand {
    @Option(name: .shortAndLong, help: "Authentication token.")
    private var token: String

    @Option(name: .shortAndLong, help: "HTTP address of InfluxDB.")
    private var url: String
}

extension InfluxDBStatus {
    mutating func run() async throws {
        // Initialize Client and API
        let client = InfluxDBClient(url: url, token: token)
        let api = InfluxDB2API(client: client)

        let headers = try await api.pingAPI.getPing()!

        let version = headers["X-Influxdb-Version"]!
        let build = headers["X-Influxdb-Build"]!

        print("InfluxDB status: UP, version: \(version), build: \(build)")

        client.close()
    }
}

