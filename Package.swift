// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "influxdb-client-swift",
    platforms: [
        .macOS(.v11),
        .iOS(.v14),
        .watchOS(.v7),
        .tvOS(.v14)
    ],
    products: [
        .library(name: "InfluxDBSwift", targets: ["InfluxDBSwift"]),
        .library(name: "InfluxDBSwiftApis", targets: ["InfluxDBSwiftApis"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
         .package(name: "Gzip", url: "https://github.com/1024jp/GzipSwift", from: "5.1.1"),
         .package(name: "SwiftCSV", url: "https://github.com/swiftcsv/SwiftCSV", from: "0.5.6"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(name: "InfluxDBSwift", dependencies: ["Gzip", "SwiftCSV"]),
        .target(name: "InfluxDBSwiftApis", dependencies: ["InfluxDBSwift"]),
        .testTarget(name: "InfluxDBSwiftTests", dependencies: ["InfluxDBSwift"]),
        .testTarget(name: "InfluxDBSwiftApisTests", dependencies: ["InfluxDBSwiftApis"]),
    ]
)
