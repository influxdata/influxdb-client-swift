// swift-tools-version:5.3

import PackageDescription

let package = Package(
        name: "DeleteData",
        products: [
            .executable(name: "delete-data", targets: ["DeleteData"])
        ],
        dependencies: [
            .package(name: "influxdb-client-swift", path: "../../"),
            .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0")
        ],
        targets: [
            .target(name: "DeleteData", dependencies: [
                .product(name: "InfluxDBSwift", package: "influxdb-client-swift"),
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ])
        ]
)
