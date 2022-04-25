// swift-tools-version:5.5

import PackageDescription

let package = Package(
        name: "InvocableScripts",
        platforms: [
            .macOS(.v10_15)
        ],
        products: [
            .executable(name: "invocable-scripts", targets: ["InvocableScripts"])
        ],
        dependencies: [
            .package(name: "influxdb-client-swift", path: "../../"),
            .package(url: "https://github.com/apple/swift-argument-parser", from: "1.1.2")
        ],
        targets: [
            .executableTarget(name: "InvocableScripts", dependencies: [
                .product(name: "InfluxDBSwift", package: "influxdb-client-swift"),
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ])
        ]
)
