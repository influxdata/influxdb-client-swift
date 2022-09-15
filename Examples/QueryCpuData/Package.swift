// swift-tools-version:5.5

import PackageDescription

let package = Package(
        name: "QueryCpuData",
        platforms: [
            .macOS(.v10_15)
        ],
        products: [
            .executable(name: "query-cpu-data", targets: ["QueryCpuData"])
        ],
        dependencies: [
            .package(name: "influxdb-client-swift", path: "../../"),
            .package(url: "https://github.com/apple/swift-argument-parser", from: "1.1.2")
        ],
        targets: [
            .executableTarget(name: "QueryCpuData", dependencies: [
                .product(name: "InfluxDBSwiftApis", package: "influxdb-client-swift"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ])
        ]
)
