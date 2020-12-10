// swift-tools-version:5.3

import PackageDescription

let package = Package(
        name: "QueryCpu",
        products: [
            .executable(name: "query-cpu", targets: ["QueryCpu"])
        ],
        dependencies: [
            .package(name: "influxdb-client-swift", path: "../../"),
            .package(url: "https://github.com/apple/swift-argument-parser", from: "0.3.0")
        ],
        targets: [
            .target(name: "QueryCpu", dependencies: [
                .product(name: "InfluxDBSwiftApis", package: "influxdb-client-swift"),
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ])
        ]
)
