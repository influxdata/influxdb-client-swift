// swift-tools-version:5.3

import PackageDescription

let package = Package(
        name: "WriteData",
        products: [
            .executable(name: "write-data", targets: ["WriteData"])
        ],
        dependencies: [
            .package(name: "influxdb-client-swift", path: "../../"),
            .package(url: "https://github.com/apple/swift-argument-parser", from: "0.3.0")
        ],
        targets: [
            .target(name: "WriteData", dependencies: [
                .product(name: "InfluxDBSwift", package: "influxdb-client-swift"),
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ])
        ]
)
