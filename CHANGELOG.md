## 1.7.0 [2024-05-17]

### Bug Fixes
1. [#63](https://github.com/influxdata/influxdb-client-swift/pull/64): Remove reference cycle

### CI
1. [#55](https://github.com/influxdata/influxdb-client-swift/pull/55): Use Swift 5.8, 5.9 and 5.10 in CI and update XCode to 15.3.0

## 1.6.0 [2022-12-01]

### Others
1. [#60](https://github.com/influxdata/influxdb-client-swift/pull/60): Update generated `PingAPI`

## 1.5.0 [2022-10-27]

### Features
1. [#57](https://github.com/influxdata/influxdb-client-swift/pull/57): Add `FluxRecord.row` which stores response data in a array

## 1.4.0 [2022-09-30]

### CI
1. [#55](https://github.com/influxdata/influxdb-client-swift/pull/55): Add Swift 5.7 to CI and update XCode

### Documentation
1. [#55](https://github.com/influxdata/influxdb-client-swift/pull/55): Updated examples in `README`, code comments and `Examples` to async/await

## 1.3.0 [2022-07-29]

### Features
1. [#52](https://github.com/influxdata/influxdb-client-swift/pull/52): Add logging for HTTP requests

## 1.2.0 [2022-05-20]

### Features
1. [#49](https://github.com/influxdata/influxdb-client-swift/pull/49): Add support `async/await` functions
1. [#48](https://github.com/influxdata/influxdb-client-swift/pull/48): Add `InvokableScriptsApi` to create, update, list, delete and invoke scripts by seamless way

### API
1. [#49](https://github.com/influxdata/influxdb-client-swift/pull/49): Update InfluxDB API to latest version [OpenAPI]

### CI
1. [#47](https://github.com/influxdata/influxdb-client-swift/pull/47): Use new Codecov uploader for reporting code coverage
1. [#49](https://github.com/influxdata/influxdb-client-swift/pull/49): Add Swift 5.6 to CI

## 1.1.0 [2022-02-18]

### Features
1. [#45](https://github.com/influxdata/influxdb-client-swift/pull/45): Add support for Parameterized Queries

### Documentation
1. [#45](https://github.com/influxdata/influxdb-client-swift/pull/45): Add Parameterized Queries example

## 1.0.0 [2022-02-04]

### Bug Fixes
1. [#46](https://github.com/influxdata/influxdb-client-swift/pull/46): Add missing PermissionResources from Cloud API definition

## 0.9.0 [2021-11-26]

### Documentation
1. [#44](https://github.com/influxdata/influxdb-client-swift/pull/44): Add an example how to use `Combine` to prepare batches for write into InfluxDB

## 0.8.0 [2021-10-22]

### Features
1. [#39](https://github.com/influxdata/influxdb-client-swift/pull/39): Add a `PingAPI to check status of OSS and Cloud instance.

### CI
1. [#39](https://github.com/influxdata/influxdb-client-swift/pull/39): Add Swift 5.5 to CI

## 0.7.0 [2021-09-17]

### Features
1. [#38](https://github.com/influxdata/influxdb-client-swift/pull/38): Add configuration option for _Proxy_ and _Redirects_

## 0.6.0 [2021-07-09]

### API
1. [#36](https://github.com/influxdata/influxdb-client-swift/pull/36): Update ManagementAPI to latest version

## 0.5.0 [2021-06-04]

### API
1. [#33](https://github.com/influxdata/influxdb-client-swift/pull/33): Update swagger to latest version
1. [#34](https://github.com/influxdata/influxdb-client-swift/pull/34): Use [openapi](https://github.com/influxdata/openapi) repository as a source for InfluxDB API definition

### CI
1. [#35](https://github.com/influxdata/influxdb-client-swift/pull/35): Add Swift 5.4 to CI

## 0.4.0 [2021-04-30]

### API
1. [#31](https://github.com/influxdata/influxdb-client-swift/pull/31): Update management API to code produced by `openapi-generator` v5.1.0
1. [#32](https://github.com/influxdata/influxdb-client-swift/pull/32): Update swagger to latest version

## 0.3.0 [2021-04-01]

### API
1. [#30](https://github.com/influxdata/influxdb-client-swift/pull/30): `WripeAPI` uses precision from the `write` call
1. [#28](https://github.com/influxdata/influxdb-client-swift/pull/28): Update management API to latest version
1. [#29](https://github.com/influxdata/influxdb-client-swift/pull/29): Update `Cursor` API to latest version

## 0.2.0 [2021-03-05]

### API
1. [#25](https://github.com/influxdata/influxdb-client-swift/pull/25): Update client API to be more Swift like
1. [#23](https://github.com/influxdata/influxdb-client-swift/pull/23), [#26](https://github.com/influxdata/influxdb-client-swift/pull/26): Update swagger to latest version

### CI
1. [#25](https://github.com/influxdata/influxdb-client-swift/pull/25): Update `SwiftLint` to 0.42.0
1. [#26](https://github.com/influxdata/influxdb-client-swift/pull/26): Update stable image to `influxdb:latest` and nightly to `quay.io/influxdb/influxdb:nightly`

## 0.1.0 [2021-01-29]

### InfluxDBSwift
initial release of new client

### InfluxDBSwiftApis
initial release of new client
