//
// Created by Jakub Bednář on 05/11/2020.
//

import ArgumentParser
import Foundation
import InfluxDBSwift
import InfluxDBSwiftApis

struct InfluxDBStatus: ParsableCommand {
    @Option(name: .shortAndLong, help: "Authentication token.")
    private var token: String

    @Option(name: .shortAndLong, help: "HTTP address of InfluxDB.")
    private var url: String

    public func run() {
        // Initialize Client and API
        let client = InfluxDBClient(url: url, token: token)
        let api = InfluxDB2API(client: client)

        api.pingAPI.getPing { headers, error in
            if let error = error {
                print("InfluxDB status: DOWN: \(error)")
                self.atExit(client: client, error: error)
            }
            if let headers = headers {
                let version = headers["X-Influxdb-Version"]
                let build = headers["X-Influxdb-Build"]
                print("InfluxDB status: UP, version: \(version), build: \(build)")
                atExit(client: client)
            }
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

InfluxDBStatus.main()
