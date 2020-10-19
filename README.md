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

## Installation

TBD

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

Bug reports and pull requests are welcome on GitHub at https://github.com/bonitoo-io/influxdb-client-swift.

## License

The client is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
