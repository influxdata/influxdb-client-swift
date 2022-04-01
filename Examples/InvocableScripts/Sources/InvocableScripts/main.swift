//
// Warning: Invocable Scripts are supported only in InfluxDB Cloud, currently there is no support in InfluxDB OSS.
//

import ArgumentParser
import Foundation
import InfluxDBSwift

struct InvocableScriptsAPI: ParsableCommand {
    @Option(name: .shortAndLong, help: "The bucket to query. The name or id of the bucket destination.")
    private var bucket: String

    @Option(name: .shortAndLong,
            help: "The organization executing the query. Takes either the `ID` or `Name` interchangeably.")
    private var org: String

    @Option(name: .shortAndLong, help: "Authentication token.")
    private var token: String

    @Option(name: .shortAndLong, help: "HTTP address of InfluxDB Cloud.")
    private var url: String

    public func run() {
        // Initialize Client with default Organization
        let client = InfluxDBClient(
                url: url,
                token: token,
                options: InfluxDBClient.InfluxDBOptions(org: self.org))

        let invocableScriptsApi = client.invocableScriptsApi

        //
        // Create Invocable Script
        //
        print("------- Create -------\n")
        let scriptQuery = "from(bucket: params.bucket_name) |> range(start: -30d) |> limit(n:2)"
        let createRequest = ScriptCreateRequest(
                name: "my_script_\(Date().timeIntervalSince1970)",
                description: "my first try",
                script: scriptQuery,
                language: ScriptLanguage.flux)

        invocableScriptsApi.createScript(createRequest: createRequest) { result in
            switch result {
            case let .success(script):
                dump(script)
                self.atExit(client: client)
            case let .failure(error):
                self.atExit(client: client, error: error)
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

InvocableScriptsAPI.main()
