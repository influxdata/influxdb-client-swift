//
// Created by Jakub Bednář on 04/11/2021.
//

import ArgumentParser
import Combine
import CSV
import Foundation
import InfluxDBSwift

struct WriteDataInBatches: ParsableCommand {
    @Option(name: .shortAndLong, help: "The name or id of the bucket destination.")
    private var bucket: String

    @Option(name: .shortAndLong, help: "The name or id of the organization destination.")
    private var org: String

    @Option(name: .shortAndLong, help: "Authentication token.")
    private var token: String

    @Option(name: .shortAndLong, help: "HTTP address of InfluxDB.")
    private var url: String

    public func run() throws {
        guard let settingsURL = Bundle.module.url(forResource: "vix-daily", withExtension: "csv") else {
            return
        }

        guard let stream = InputStream(url: settingsURL) else {
            return
        }

        var subscriptions = Set<AnyCancellable>()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        // Initialize Client with default Bucket and Organization
        let client = InfluxDBClient(
                url: url,
                token: token,
                options: InfluxDBClient.InfluxDBOptions(bucket: self.bucket, org: self.org))

        // Initialize WriteAPI
        let writeAPI = client.makeWriteAPI()

        // Prepare batches by Combine
        let batches = try CSVReader(stream: stream, hasHeaderRow: true)
                .publisher
                // create Point from CSV line
                .map { row in
                    toPoint(row: row, dateFormatter: dateFormatter)
                }
                // specify size of batch
                .collect(500)
                // write batch
                .flatMap(maxPublishers: .max(1)) { batch -> AnyPublisher<Void, InfluxDBClient.InfluxDBError> in
                    print("Writing \(batch.count) items ...")
                    return writeAPI.write(points: batch)
                }

        batches
                .sink(receiveCompletion: { result in
                    // process result of import
                    switch result {
                    case .finished:
                       print("Import finished!")
                    case let .failure(error):
                       print("Unexpected error: \(error)")
                    }
                    self.atExit(client: client)
                }, receiveValue: {
                    // batch is successfully written
                    print(" > success")
                })
                .store(in: &subscriptions)

        // Wait to end of script
        RunLoop.current.run()
    }

    /// Parse the CSV line into Point
    ///
    /// - Parameters:
    ///   - row: CSV line
    ///   - dateFormatter: for parsing date
    /// - Returns: parsed InfluxDBClient.Point
    private func toPoint(row: [String], dateFormatter: DateFormatter) -> InfluxDBClient.Point {
        InfluxDBClient
                .Point("financial-analysis")
                .addTag(key: "type", value: "vix-daily")
                .addField(key: "open", value: .double(Double(row[1])!))
                .addField(key: "high", value: .double(Double(row[2])!))
                .addField(key: "low", value: .double(Double(row[3])!))
                .addField(key: "close", value: .double(Double(row[4])!))
                .time(time: .date(dateFormatter.date(from: row[0])!))
    }

    private func atExit(client: InfluxDBClient, error: InfluxDBClient.InfluxDBError? = nil) {
        // Dispose the Client
        client.close()
        // Exit script
        Self.exit(withError: error)
    }
}

// extension CSVReader: Sequence { }

WriteDataInBatches.main()
