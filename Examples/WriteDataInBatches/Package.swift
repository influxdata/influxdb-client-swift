// swift-tools-version:5.3

import PackageDescription

let package = Package(
        name: "WriteDataInBatches",
        platforms: [
            .macOS(.v11)
        ],
        products: [
            .executable(name: "write-data-in-batches", targets: ["WriteDataInBatches"])
        ],
        dependencies: [
            .package(name: "influxdb-client-swift", path: "../../"),
            .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0")
        ],
        targets: [
            .target(name: "WriteDataInBatches", dependencies: [
                .product(name: "InfluxDBSwift", package: "influxdb-client-swift"),
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ], resources: [.process("vix-daily.csv")])
        ]
)
