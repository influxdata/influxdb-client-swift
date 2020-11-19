# influxdb-client-swift

[![CircleCI](https://circleci.com/gh/bonitoo-io/influxdb-client-swift.svg?style=svg)](https://circleci.com/gh/bonitoo-io/influxdb-client-swift)
[![codecov](https://codecov.io/gh/bonitoo-io/influxdb-client-swift/branch/master/graph/badge.svg)](https://codecov.io/gh/bonitoo-io/influxdb-client-swift)
[![License](https://img.shields.io/github/license/bonitoo-io/influxdb-client-swift.svg)](https://github.com/bonitoo-io/influxdb-client-swift/blob/master/LICENSE)
[![Latest Version](https://img.shields.io/cocoapods/v/InfluxDBSwift.svg)](https://cocoapods.org/pods/InfluxDBSwift)
[![Cocoapods platforms](https://img.shields.io/cocoapods/p/InfluxDBSwift.svg)](https://cocoapods.org/pods/InfluxDBSwift)
[![Documentation](https://img.shields.io/badge/docs-latest-blue)](https://bonitoo-io.github.io/influxdb-client-swift/)
[![GitHub issues](https://img.shields.io/github/issues-raw/bonitoo-io/influxdb-client-swift.svg)](https://github.com/bonitoo-io/influxdb-client-swift/issues)
[![GitHub pull requests](https://img.shields.io/github/issues-pr-raw/bonitoo-io/influxdb-client-swift.svg)](https://github.com/bonitoo-io/influxdb-client-swift/pulls)
[![Slack Status](https://img.shields.io/badge/slack-join_chat-white.svg?logo=slack&style=social)](https://www.influxdata.com/slack)

This repository contains the reference Swift client for the InfluxDB 2.0.

#### Disclaimer: This library is a work in progress and should not be considered production ready yet.

- [Features](#features)
- [Supported Platforms](#supported-platforms)
- [Installation](#installation)
    - [Swift Package Manager](#swift-package-manager)
    - [CocoaPods](#cocoapods)
- [Usage](#usage)
    - [Creating a client](#creating-a-client)
    - [Writing data](#writes)
    - [Querying data](#queries)
    - [Management API](#management-api)
- [Contributing](#contributing)
- [License](#license)

## Features

InfluxDB 2.0 client consists of two packages

- `InfluxDBSwift`
  - Querying data using the Flux language
  - Writing data
    - batched in chunks on background
    - automatic retries on write failures
- `InfluxDBSwiftApis`
  - provides all other InfluxDB 2.0 APIs for managing
    - health check
    - sources, buckets
    - tasks
    - authorizations
    - ...
  - built on top of `InfluxDBSwift`

## Supported Platforms

This package requires Swift 5 and Xcode 12.

- iOS 14.0+
- macOS 11.0+
- tvOS 14.0+
- watchOS 7.0+
- Linux

## Installation

### Swift Package Manager

Add this line to your `Package.swift` :

~~~swift
.Package(url: "https://github.com/bonitoo-io/influxdb-client-swift", from: "0.0.1")
// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "MyPackage",
    dependencies: [
        .package(url: "https://github.com/bonitoo-io/influxdb-client-swift", from: "0.0.1"),
    ],
    targets: [
        .target(name: "MyModule", dependencies: ["InfluxDBSwift"])
    ]
)
~~~

### CocoaPods

Add this line to your `Podfile`:

~~~ruby
pod 'InfluxDBSwift', '~> 0.0.1'
~~~

## Usage

> Important: You should call `close()` at the end of your application to release allocated resources.

### Creating a client
Specify **url** and **token** via parameters:

```swift
let client = InfluxDBClient(url: "http://localhost:8086", token: "my-token")

...

client.close()
```

#### Client Options

| Option | Description | Type | Default |
|---|---|---|---|
| bucket | Default destination bucket for writes | String | none |
| org | Default organization bucket for writes | String | none |
| precision | Default precision for the unix timestamps within the body line-protocol | WritePrecision | ns |
| timeoutIntervalForRequest | The timeout interval to use when waiting for additional data. | TimeInterval | 60 sec |
| timeoutIntervalForResource | The maximum amount of time that a resource request should be allowed to take. | TimeInterval | 5 min |
| enableGzip | Enable Gzip compression for HTTP requests. | Bool | false |

##### Configure default `Bucket`, `Organization` and `Precision`

```swift
let options: InfluxDBClient.InfluxDBOptions = InfluxDBClient.InfluxDBOptions(
        bucket: "my-bucket",
        org: "my-org",
        precision: InfluxDBClient.WritePrecision.ns)

let client = InfluxDBClient(url: "http://localhost:8086", token: "my-token", options: options)

...

client.close()
```

#### InfluxDB 1.8 API compatibility

```swift
client = InfluxDBClient(
        url: "http://localhost:8086", 
        username: "user", 
        password: "pass",
        database: "my-db", 
        retentionPolicy: "autogen")

...

client.close()
```

### Writes

The WriteApi supports asynchronous writes into InfluxDB 2.0. 
The results of writes could be handled by `(response, error)`, `Swift.Result` or `Combine`.

The data could be written as:

1. `String` that is formatted as a InfluxDB's Line Protocol
1. [Data Point](https://github.com/bonitoo-io/influxdb-client-swift/blob/master/Sources/InfluxDBSwift/Point.swift#L11) structure
1. Tuple style mapping with keys: `measurement`, `tags`, `fields` and `time`
1. List of above items

The following example demonstrates how to write data with different type of records. For further information see docs and [examples](/Examples).

```swift
import ArgumentParser
import Foundation
import InfluxDBSwift

struct WriteData: ParsableCommand {
    @Option(name: .shortAndLong, help: "The name or id of the bucket destination.")
    private var bucket: String

    @Option(name: .shortAndLong, help: "The name or id of the organization destination.")
    private var org: String

    @Option(name: .shortAndLong, help: "Authentication token.")
    private var token: String

    @Option(name: .shortAndLong, help: "HTTP address of InfluxDB.")
    private var url: String

    public func run() {
        // Initialize Client with default Bucket and Organization
        let client = InfluxDBClient(
                url: url,
                token: token,
                options: InfluxDBClient.InfluxDBOptions(bucket: self.bucket, org: self.org))

        //
        // Record defined as String
        //
        let recordString = "demo,type=string value=1i"
        //
        // Record defined as Data Point
        //
        let recordPoint = InfluxDBClient
                .Point("demo")
                .addTag(key: "type", value: "point")
                .addField(key: "value", value: 2)
        //
        // Record defined as Data Point with Timestamp
        //
        let recordPointDate = InfluxDBClient
                .Point("demo")
                .addTag(key: "type", value: "point-timestamp")
                .addField(key: "value", value: 2)
                .time(time: Date())
        //
        // Record defined as Tuple
        //
        let recordTuple = (measurement: "demo", tags: ["type": "tuple"], fields: ["value": 3])

        let records: [Any] = [recordString, recordPoint, recordPointDate, recordTuple]

        client.getWriteAPI().writeRecords(records: records) { result, error in
            // For handle error
            if let error = error {
                self.atExit(client: client, error: error)
            }

            // For Success write
            if result != nil {
                print("Successfully written data:\n\n\(records)")
            }

            self.atExit(client: client)
        }

        // Wait to end of script
        RunLoop.current.run()
    }

    private func atExit(client: InfluxDBClient, error: InfluxDBClient.InfluxDBError? = nil) {
        // Dispose the Client
        client.close()
        // Exit script
        Self.exit(withError: error)
    }
}

WriteData.main()

```
- sources - [WriteData/main.swift](https://github.com/bonitoo-io/influxdb-client-swift/blob/master/Examples/WriteData/Sources/WriteData/main.swift)

### Queries

TBP

### Management API

The client supports following management API:

|  | API docs |
| --- | --- |
| [**AuthorizationsAPI**](https://bonitoo-io.github.io/influxdb-client-swift/Classes/InfluxDB2API/AuthorizationsAPI.html) | https://docs.influxdata.com/influxdb/v2.0/api/#tag/Authorizations |
| [**BucketsAPI**](https://bonitoo-io.github.io/influxdb-client-swift/Classes/InfluxDB2API/BucketsAPI.html) | https://docs.influxdata.com/influxdb/v2.0/api/#tag/Buckets |
| [**DBRPsAPI**](https://bonitoo-io.github.io/influxdb-client-swift/Classes/InfluxDB2API/DBRPsAPI.html) | https://docs.influxdata.com/influxdb/v2.0/api/#tag/DBRPs |
| [**HealthAPI**](https://bonitoo-io.github.io/influxdb-client-swift/Classes/InfluxDB2API/HealthAPI.html) | https://docs.influxdata.com/influxdb/v2.0/api/#tag/Health |
| [**LabelsAPI**](https://bonitoo-io.github.io/influxdb-client-swift/Classes/InfluxDB2API/LabelsAPI.html) | https://docs.influxdata.com/influxdb/v2.0/api/#tag/Labels |
| [**OrganizationsAPI**](https://bonitoo-io.github.io/influxdb-client-swift/Classes/InfluxDB2API/OrganizationsAPI.html) | https://docs.influxdata.com/influxdb/v2.0/api/#tag/Organizations |
| [**ReadyAPI**](https://bonitoo-io.github.io/influxdb-client-swift/Classes/InfluxDB2API/ReadyAPI.html) | https://docs.influxdata.com/influxdb/v2.0/api/#tag/Ready |
| [**ScraperTargetsAPI**](https://bonitoo-io.github.io/influxdb-client-swift/Classes/InfluxDB2API/ScraperTargetsAPI.html) | https://docs.influxdata.com/influxdb/v2.0/api/#tag/ScraperTargets |
| [**SecretsAPI**](https://bonitoo-io.github.io/influxdb-client-swift/Classes/InfluxDB2API/SecretsAPI.html) | https://docs.influxdata.com/influxdb/v2.0/api/#tag/Secrets|
| [**SetupAPI**](https://bonitoo-io.github.io/influxdb-client-swift/Classes/InfluxDB2API/SetupAPI.html) | https://docs.influxdata.com/influxdb/v2.0/api/#tag/Tasks |
| [**SourcesAPI**](https://bonitoo-io.github.io/influxdb-client-swift/Classes/InfluxDB2API/SourcesAPI.html) | https://docs.influxdata.com/influxdb/v2.0/api/#tag/Sources |
| [**TasksAPI**](https://bonitoo-io.github.io/influxdb-client-swift/Classes/InfluxDB2API/TasksAPI.html) | https://docs.influxdata.com/influxdb/v2.0/api/#tag/Tasks |
| [**UsersAPI**](https://bonitoo-io.github.io/influxdb-client-swift/Classes/InfluxDB2API/UsersAPI.html) | https://docs.influxdata.com/influxdb/v2.0/api/#tag/Users |
| [**VariablesAPI**](https://bonitoo-io.github.io/influxdb-client-swift/Classes/InfluxDB2API/VariablesAPI.html) | https://docs.influxdata.com/influxdb/v2.0/api/#tag/Variables |


The following example demonstrates how to use a InfluxDB 2.0 Management API to create new bucket. For further information see docs and [examples](/Examples).

```swift
import ArgumentParser
import Foundation
import InfluxDBSwift
import InfluxDBSwiftApis

struct CreateNewBucket: ParsableCommand {
    @Option(name: .shortAndLong, help: "New bucket name.")
    private var name: String

    @Option(name: .shortAndLong, help: "Duration bucket will retain data.")
    private var retention: Int = 3600

    @Option(name: .shortAndLong, help: "The ID of the organization.")
    private var orgId: String

    @Option(name: .shortAndLong, help: "Authentication token.")
    private var token: String

    @Option(name: .shortAndLong, help: "HTTP address of InfluxDB.")
    private var url: String

    public func run() {
        // Initialize Client and API
        let client = InfluxDBClient(url: url, token: token)
        let api = InfluxDB2API(client: client)

        // Bucket configuration
        let request = PostBucketRequest(
                orgID: self.orgId,
                name: self.name,
                retentionRules: [RetentionRule(type: RetentionRule.ModelType.expire, everySeconds: self.retention)])

        // Create Bucket
        api.getBucketsAPI().postBuckets(postBucketRequest: request) { bucket, error in
            // For error exit
            if let error = error {
                self.atExit(client: client, error: error)
            }

            if let bucket = bucket {
                // Create Authorization with permission to read/write created bucket
                let bucketResource = Resource(
                        type: Resource.ModelType.buckets,
                        id: bucket.id!,
                        orgID: self.orgId
                )
                // Authorization configuration
                let request = Authorization(
                        description: "Authorization to read/write bucket: \(self.name)",
                        orgID: self.orgId,
                        permissions: [
                            Permission(action: Permission.Action.read, resource: bucketResource),
                            Permission(action: Permission.Action.write, resource: bucketResource)
                        ])

                // Create Authorization
                api.getAuthorizationsAPI().postAuthorizations(authorization: request) { authorization, error in
                    // For error exit
                    if let error = error {
                        atExit(client: client, error: error)
                    }

                    // Print token
                    if let authorization = authorization {
                        let token = authorization.token!
                        print("The token: '\(token)' is authorized to read/write from/to bucket: '\(bucket.id!)'.")
                        atExit(client: client)
                    }
                }
            }
        }

        // Wait to end of script
        RunLoop.current.run()
    }

    private func atExit(client: InfluxDBClient, error: InfluxDBError? = nil) {
        // Dispose the Client
        client.close()
        // Exit script
        Self.exit(withError: error)
    }
}

CreateNewBucket.main()

```
- sources - [CreateNewBucket/main.swift](https://github.com/bonitoo-io/influxdb-client-swift/blob/master/Examples/CreateNewBucket/Sources/CreateNewBucket/main.swift)

## Contributing

If you would like to contribute code you can do through GitHub by forking the repository and sending a pull request into the `master` branch.

Build Requirements:

- swift 5.3 or higher

Build source and test targets:

```bash
$ swift build --build-tests
```

Run tests:

```bash
$ swift test
```

Check code coverage:

```bash
$ swift test --enable-code-coverage
```

You could also use a `docker-cli` without installing the Swift SDK:

```bash
make docker-cli
swift build
```

## License

The client is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
