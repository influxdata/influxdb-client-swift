// swift-tools-version:5.3

import PackageDescription

let package = Package(
        name: "CreateNewBucket",
        products: [
            .executable(name: "create-new-bucket", targets: ["CreateNewBucket"])
        ],
        dependencies: [
            .package(name: "influxdb-client-swift", path: "../../"),
            .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0")
        ],
        targets: [
            .target(name: "CreateNewBucket", dependencies: [
                .product(name: "InfluxDBSwiftApis", package: "influxdb-client-swift"),
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ])
        ]
)
