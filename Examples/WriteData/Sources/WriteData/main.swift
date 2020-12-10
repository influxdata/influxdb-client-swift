//
// Created by Jakub Bednář on 05/11/2020.
//

import ArgumentParser
import Foundation
import InfluxDBSwift

struct WriteData: ParsableCommand {
    @Option(name: .shortAndLong, help: "The name or id of the bucket destination.")
    private var bucket: String

    @Option(name: .shortAndLong, help: "The name or id of the organization destination.")
    private var org: String

    @Option(name: .shortAndLong, help: "Authentication token.")
    private var token: String

    @Option(name: .shortAndLong, help: "HTTP address of InfluxDB.")
    private var url: String

    public func run() {
        // Initialize Client with default Bucket and Organization
        let client = InfluxDBClient(
                url: url,
                token: token,
                options: InfluxDBClient.InfluxDBOptions(bucket: self.bucket, org: self.org))

        //
        // Record defined as String
        //
        let recordString = "demo,type=string value=1i"
        //
        // Record defined as Data Point
        //
        let recordPoint = InfluxDBClient
                .Point("demo")
                .addTag(key: "type", value: "point")
                .addField(key: "value", value: 2)
        //
        // Record defined as Data Point with Timestamp
        //
        let recordPointDate = InfluxDBClient
                .Point("demo")
                .addTag(key: "type", value: "point-timestamp")
                .addField(key: "value", value: 2)
                .time(time: Date())
        //
        // Record defined as Tuple
        //
        let recordTuple = (measurement: "demo", tags: ["type": "tuple"], fields: ["value": 3])

        let records: [Any] = [recordString, recordPoint, recordPointDate, recordTuple]

        client.getWriteAPI().writeRecords(records: records) { result, error in
            // For handle error
            if let error = error {
                self.atExit(client: client, error: error)
            }

            // For Success write
            if result != nil {
                print("Written data:\n\n\(records.map { "\t- \($0)" }.joined(separator: "\n"))")
                print("\nSuccess!")
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

WriteData.main()
