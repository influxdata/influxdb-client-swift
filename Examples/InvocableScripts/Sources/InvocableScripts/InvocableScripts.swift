//
// Warning: Invocable Scripts are supported only in InfluxDB Cloud, currently there is no support in InfluxDB OSS.
//

import ArgumentParser
import Foundation
import InfluxDBSwift

@main
struct InvocableScriptsAPI: AsyncParsableCommand {
    @Option(name: .shortAndLong, help: "The bucket to query. The name or id of the bucket destination.")
    private var bucket: String

    @Option(name: .shortAndLong,
            help: "The organization executing the query. Takes either the `ID` or `Name` interchangeably.")
    private var org: String

    @Option(name: .shortAndLong, help: "Authentication token.")
    private var token: String

    @Option(name: .shortAndLong, help: "HTTP address of InfluxDB Cloud.")
    private var url: String
}

extension InvocableScriptsAPI {
    mutating func run() async throws {
        //
        // Initialize Client with default Organization
        //
        let client = InfluxDBClient(
                url: url,
                token: token,
                options: InfluxDBClient.InfluxDBOptions(bucket: self.bucket, org: self.org))

        let invocableScriptsApi = client.invocableScriptsApi

        //
        // Prepare Data
        //
        let point1 = InfluxDBClient
                .Point("my_measurement")
                .addTag(key: "location", value: "Prague")
                .addField(key: "temperature", value: .double(25.3))
        let point2 = InfluxDBClient
                .Point("my_measurement")
                .addTag(key: "location", value: "New York")
                .addField(key: "temperature", value: .double(24.3))
        try await client.makeWriteAPI().write(points: [point1, point2])

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

        let createdScript = try await invocableScriptsApi.createScript(createRequest: createRequest)
        guard let createdScript = createdScript else {
            return
        }
        dump(createdScript)

        //
        // Update Invocable Script
        //
        print("\n------- Update -------\n")
        let updateRequest = ScriptUpdateRequest(description: "my updated description")
        let updatedScript = try await invocableScriptsApi.updateScript(scriptId: createdScript.id!, updateRequest: updateRequest)
        guard let updatedScript = updatedScript else {
            return
        }
        dump(updatedScript)

        //
        // List Invocable Scripts
        //
        print("\n------- List -------\n")
        let scripts = try await invocableScriptsApi.findScripts()
        print("Scripts:")
        scripts?.scripts?.forEach { print(" > \($0.id ?? ""): \($0.name): \($0.description ?? "")") }

        //
        // Invoke a Script
        //
        // FluxRecords
        print("\n------- Invoke to FluxRecords -------\n")
        let records = try await invocableScriptsApi.invokeScript(
                scriptId: updatedScript.id!,
                params: ["bucket_name": "\(self.bucket)"])
        try records.forEach { record in
            print("\t\(record.values["_field"]!): \(record.values["_value"]!)")
        }
        // Raw
        print("\n------- Invoke to Raw -------\n")
        let raw = try await invocableScriptsApi.invokeScriptRaw(
                scriptId: updatedScript.id!,
                params: ["bucket_name": "\(self.bucket)"])
        print("RAW output:\n\n \(String(decoding: raw, as: UTF8.self))")

        //
        // Delete previously created Script
        //
        print("\n------- Delete -------\n")
        try await invocableScriptsApi.deleteScript(scriptId: updatedScript.id!)
        print("Successfully deleted script: '\(updatedScript.name)'")

        client.close()
    }
}
