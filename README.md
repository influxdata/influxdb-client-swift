# influxdb-client-swift

[![CircleCI](https://circleci.com/gh/bonitoo-io/influxdb-client-swift.svg?style=svg)](https://circleci.com/gh/bonitoo-io/influxdb-client-swift)
[![codecov](https://codecov.io/gh/bonitoo-io/influxdb-client-swift/branch/master/graph/badge.svg)](https://codecov.io/gh/bonitoo-io/influxdb-client-swift)
[![License](https://img.shields.io/github/license/bonitoo-io/influxdb-client-swift.svg)](https://github.com/bonitoo-io/influxdb-client-swift/blob/master/LICENSE)
[![Latest Version](https://img.shields.io/cocoapods/v/influxdb_client_swift.svg)](https://cocoapods.org/pods/influxdb_client_swift)
[![Cocoapods platforms](https://img.shields.io/cocoapods/p/influxdb_client_swift.svg)](https://cocoapods.org/pods/influxdb_client_swift)
[![Documentation](https://img.shields.io/badge/docs-latest-blue)](https://bonitoo-io.github.io/influxdb-client-swift/)
[![GitHub issues](https://img.shields.io/github/issues-raw/bonitoo-io/influxdb-client-swift.svg)](https://github.com/bonitoo-io/influxdb-client-swift/issues)
[![GitHub pull requests](https://img.shields.io/github/issues-pr-raw/bonitoo-io/influxdb-client-swift.svg)](https://github.com/bonitoo-io/influxdb-client-swift/pulls)
[![Slack Status](https://img.shields.io/badge/slack-join_chat-white.svg?logo=slack&style=social)](https://www.influxdata.com/slack)

This repository contains the reference Swift client for the InfluxDB 2.0.

#### Disclaimer: This library is a work in progress and should not be considered production ready yet.

## Features

TBD

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
~~~

### CocoaPods

Add this line to your `Podfile`:

~~~ruby
pod 'influxdb-client-swift', '~> 0.0.1'
~~~

### Carthage

Add this line to your Cartfile:

~~~
github "bonitoo-io/influxdb-client-swift" ~> 0.0.1
~~~

## Usage

### Creating a client

TBD

#### Client Options

| Option | Description | Type | Default |
|---|---|---|---|
| bucket | Default destination bucket for writes | String | none |
| org | Default organization bucket for writes | String | none |
| precision | Default precision for the unix timestamps within the body line-protocol | WritePrecision | ns |

##### Configure default `Bucket`, `Organization` and `Precision`

TBD

#### InfluxDB 1.8 API compatibility

TBD

## Contributing

If you would like to contribute code you can do through GitHub by forking the repository and sending a pull request into the `master` branch.

Build Requirements:

- swift 5.3 or higher

Run tests:

```bash
$ swift test
```

Check code coverage:

```bash
$ swift test --enable-code-coverage
```

Build distributions:

```bash
$ swift build
```

## License

The client is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
