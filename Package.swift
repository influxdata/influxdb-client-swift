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
        .package(url: "https://github.com/WeTransfer/Mocker.git", .upToNextMajor(from: "2.3.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(name: "InfluxDBSwift", dependencies: []),
        .target(name: "InfluxDBSwiftApis", dependencies: ["InfluxDBSwift"]),
        .testTarget(name: "InfluxDBSwiftTests", dependencies: ["InfluxDBSwift", "Mocker"]),
        .testTarget(name: "InfluxDBSwiftApisTests", dependencies: ["InfluxDBSwiftApis"]),
    ]
)
