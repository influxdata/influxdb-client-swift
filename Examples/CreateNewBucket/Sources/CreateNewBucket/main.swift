//
// Created by Jakub Bednář on 05/11/2020.
//

import ArgumentParser

struct CreateNewBucket: ParsableCommand {
    @Option(name: .shortAndLong, help: "New bucket name.")
    private var name: String

    @Option(name: .shortAndLong, help: "Duration bucket will retain data.")
    private var retention: Int = 0

    @Option(name: .shortAndLong, help: "Authentication token.")
    private var token: String

    @Option(name: .shortAndLong, help: "HTTP address of InfluxDB.")
    private var url: String

    public func run() {
        print("Settings: \(name) \(token) \(url)")
    }
}

CreateNewBucket.main()
