# RecordRow

Using 'FluxRecord.row' in case of duplicated column names in response.

## Prerequisites:
- Docker
- Cloned examples:
   ```bash
   git clone git@github.com:influxdata/influxdb-client-swift.git
   cd Examples/RecordRow
   ```

## Sources:
- [Package.swift](/Examples/RecordRow/Package.swift)
- [RecordRow.swift](/Examples/RecordRow/Sources/RecordRow/RecordRow.swift)

## How to test:
1. Start InfluxDB:
    ```bash
    docker run --rm \
      --name influxdb_v2 \
      --detach \
      --publish 8086:8086 \
      influxdb:latest
    ```
2. Configure your username, password, organization, bucket and token:
   ```bash
   docker run --rm \
      --link influxdb_v2 \
      curlimages/curl -s -i -X POST http://influxdb_v2:8086/api/v2/setup \
         -H 'accept: application/json' \
         -d '{"username": "my-user", "password": "my-password", "org": "my-org", "bucket": "my-bucket", "token": "my-token"}'
   ```
3. Start SwiftCLI by:
   ```bash
    docker run --rm \
      --link influxdb_v2 \
      --privileged \
      --interactive \
      --tty \
      --volume $PWD/../..:/client \
      --workdir /client/Examples/RecordRow \
      swift:5.7 /bin/bash
   ```
4. Execute by:
   ```bash
   swift run record-row --org my-org --bucket my-bucket --token my-token --url http://influxdb_v2:8086
   ```

## Expected output

```bash
The response contains columns with duplicated names: result, table
You should use the 'FluxRecord.row' to access your data instead of 'FluxRecord.values' dictionary.
------------------------------------------ FluxRecord.values ------------------------------------------
_measurement: point, _start: 2022-10-13 07:56:08 +0000, _stop: 2022-10-13 07:57:08 +0000, _time: 2022-10-13 07:57:08 +0000, result: 1.0, table: my-table
_measurement: point, _start: 2022-10-13 07:56:08 +0000, _stop: 2022-10-13 07:57:08 +0000, _time: 2022-10-13 07:57:08 +0000, result: 2.0, table: my-table
_measurement: point, _start: 2022-10-13 07:56:08 +0000, _stop: 2022-10-13 07:57:08 +0000, _time: 2022-10-13 07:57:08 +0000, result: 3.0, table: my-table
_measurement: point, _start: 2022-10-13 07:56:08 +0000, _stop: 2022-10-13 07:57:08 +0000, _time: 2022-10-13 07:57:08 +0000, result: 4.0, table: my-table
_measurement: point, _start: 2022-10-13 07:56:08 +0000, _stop: 2022-10-13 07:57:08 +0000, _time: 2022-10-13 07:57:08 +0000, result: 5.0, table: my-table
-------------------------------------------- FluxRecord.row -------------------------------------------
_result, 0, 2022-10-13 07:56:08 +0000, 2022-10-13 07:57:08 +0000, 2022-10-13 07:57:08 +0000, point, 1.0, my-table
_result, 0, 2022-10-13 07:56:08 +0000, 2022-10-13 07:57:08 +0000, 2022-10-13 07:57:08 +0000, point, 2.0, my-table
_result, 0, 2022-10-13 07:56:08 +0000, 2022-10-13 07:57:08 +0000, 2022-10-13 07:57:08 +0000, point, 3.0, my-table
_result, 0, 2022-10-13 07:56:08 +0000, 2022-10-13 07:57:08 +0000, 2022-10-13 07:57:08 +0000, point, 4.0, my-table
_result, 0, 2022-10-13 07:56:08 +0000, 2022-10-13 07:57:08 +0000, 2022-10-13 07:57:08 +0000, point, 5.0, my-table

```
