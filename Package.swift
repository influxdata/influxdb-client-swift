// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "influxdb-client-swift",
    products: [
        .library(name: "InfluxDBSwift", targets: ["InfluxDBSwift"]),
        .library(name: "InfluxDBSwiftApis", targets: ["InfluxDBSwiftApis"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
         .package(name: "Gzip", url: "https://github.com/1024jp/GzipSwift", from: "5.1.1"),
         .package(name: "CSV.swift", url: "https://github.com/yaslab/CSV.swift", from: "2.4.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(name: "InfluxDBSwift", dependencies: ["Gzip", .product(name: "CSV", package: "CSV.swift")]),
        .target(name: "InfluxDBSwiftApis", dependencies: ["InfluxDBSwift"]),
        .testTarget(name: "InfluxDBSwiftTests", dependencies: ["InfluxDBSwift"]),
        .testTarget(name: "InfluxDBSwiftApisTests", dependencies: ["InfluxDBSwiftApis"]),
    ]
)
