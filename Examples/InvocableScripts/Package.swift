// swift-tools-version:5.3

import PackageDescription

let package = Package(
        name: "InvocableScripts",
        products: [
            .executable(name: "invocable-scripts", targets: ["InvocableScripts"])
        ],
        dependencies: [
            .package(name: "influxdb-client-swift", path: "../../"),
            .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0")
        ],
        targets: [
            .target(name: "InvocableScripts", dependencies: [
                .product(name: "InfluxDBSwift", package: "influxdb-client-swift"),
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ])
        ]
)
