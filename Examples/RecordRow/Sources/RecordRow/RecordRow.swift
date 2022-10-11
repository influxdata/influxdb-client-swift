import ArgumentParser
import Foundation
import InfluxDBSwift
import InfluxDBSwiftApis

@main
struct RecordRow: AsyncParsableCommand {
    @Option(name: .shortAndLong, help: "The name or id of the bucket destination.")
    private var bucket: String

    @Option(name: .shortAndLong, help: "The name or id of the organization destination.")
    private var org: String

    @Option(name: .shortAndLong, help: "Authentication token.")
    private var token: String

    @Option(name: .shortAndLong, help: "HTTP address of InfluxDB.")
    private var url: String
}

extension RecordRow {
    mutating func run() async throws {
        //
        // Creating client
        //
        let client = InfluxDBClient(
                url: url,
                token: token,
                options: InfluxDBClient.InfluxDBOptions(bucket: bucket, org: org))

        //
        // Write test data into InfluxDB
        //
        for i in 1...5 {
            let point = InfluxDBClient
                    .Point("point")
                    .addField(key: "table", value: .string("my-table"))
                    .addField(key: "result", value: .double(Double(i)))
            try await client.makeWriteAPI().write(point: point)
        }

        //
        // Query data with pivot
        //
        let query = """
                    from(bucket: "\(self.bucket)")
                    |> range(start: -1m) 
                    |> filter(fn: (r) => (r["_measurement"] == "point"))
                    |> pivot(rowKey:["_time"], columnKey: ["_field"], valueColumn: "_value")
                    """
        let records = try await client.queryAPI.query(query: query)

        //
        // Write data to output
        //
        var values: Array<String> = Array()
        var row: Array<String> = Array()

        try records.forEach { record in
            values.append(record.values.sorted(by: { $0.0 < $1.0 }).map {
                        val in
                        "\(val.key): \(val.value)"
                    }
                    .joined(separator: ", "))
            row.append(record.row.compactMap { val in
                        "\(val)"
                    }
                    .joined(separator: ", "))
        }

        print("------------------------------------------ FluxRecord.values ------------------------------------------")
        print(values.joined(separator: "\n"))
        print("-------------------------------------------- FluxRecord.row -------------------------------------------")
        print(row.joined(separator: "\n"))

        client.close()
    }
}
