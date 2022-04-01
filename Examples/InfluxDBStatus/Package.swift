// swift-tools-version:5.3

import PackageDescription

let package = Package(
        name: "InfluxDBStatus",
        products: [
            .executable(name: "influxdb-status", targets: ["InfluxDBStatus"])
        ],
        dependencies: [
            .package(name: "influxdb-client-swift", path: "../../"),
            .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0")
        ],
        targets: [
            .target(name: "InfluxDBStatus", dependencies: [
                .product(name: "InfluxDBSwiftApis", package: "influxdb-client-swift"),
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ])
        ]
)
