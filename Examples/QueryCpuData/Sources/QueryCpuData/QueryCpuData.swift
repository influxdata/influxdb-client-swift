import ArgumentParser
import Foundation
import InfluxDBSwift
import InfluxDBSwiftApis

@main
struct QueryCpuData: AsyncParsableCommand {
    @Option(name: .shortAndLong, help: "The name or id of the bucket destination.")
    private var bucket: String

    @Option(name: .shortAndLong, help: "The name or id of the organization destination.")
    private var org: String

    @Option(name: .shortAndLong, help: "Authentication token.")
    private var token: String

    @Option(name: .shortAndLong, help: "HTTP address of InfluxDB.")
    private var url: String
}

extension QueryCpuData {
    mutating func run() async throws {
        //
        // Initialize Client with default Bucket and Organization
        //
        let client = InfluxDBClient(
                url: url,
                token: token,
                options: InfluxDBClient.InfluxDBOptions(bucket: bucket, org: org))

        // Flux query
        let query = """
                    from(bucket: "\(self.bucket)")
                        |> range(start: -10m)
                        |> filter(fn: (r) => r["_measurement"] == "cpu")
                        |> filter(fn: (r) => r["cpu"] == "cpu-total")
                        |> filter(fn: (r) => r["_field"] == "usage_user" or r["_field"] == "usage_system")
                        |> last()
                    """

        print("\nQuery to execute:\n\(query)\n")

        let response = try await client.queryAPI.queryRaw(query: query)

        let csv = String(decoding: response, as: UTF8.self)
        print("InfluxDB response: \(csv)")

        client.close()
    }
}
