# WriteData

This is an example how to write data with different type of records.

## Prerequisites:
- Docker
- Cloned examples:
   ```bash
   git clone git@github.com:influxdata/influxdb-client-swift.git
   cd Examples/WriteData
   ```

## Sources:
- [Package.swift](/Examples/WriteData/Package.swift)
- [main.swift](/Examples/WriteData/Sources/WriteData/main.swift)

## How to test:
1. Start InfluxDB:
    ```bash
    docker run --rm \
      --name influxdb_v2 \
      --detach \
      --publish 8086:8086 \
      quay.io/influxdb/influxdb:v2.0.3
    ```
1. Configure your username, password, organization, bucket and token:
   ```bash
   docker run --rm \
      --link influxdb_v2 \
      curlimages/curl -s -i -X POST http://influxdb_v2:8086/api/v2/setup \
         -H 'accept: application/json' \
         -d '{"username": "my-user", "password": "my-password", "org": "my-org", "bucket": "my-bucket", "token": "my-token"}'
   ```
1. Start SwiftCLI by:
   ```bash
    docker run --rm \
      --link influxdb_v2 \
      --privileged \
      --interactive \
      --tty \
      --volume $PWD/../..:/client \
      --workdir /client/Examples/WriteData \
      swift:5.3 /bin/bash
   ```
1. Write data by:
   ```bash
   swift run write-data --bucket my-bucket --org my-org --token my-token --url http://influxdb_v2:8086
   ```

## Expected output

```bash
Written data:

        - demo,type=string value=1i
        - Point: measurement:demo, tags:["type": Optional("point")], fields:["value": Optional(2)], time:nil
        - Point: measurement:demo, tags:["type": Optional("point-timestamp")], fields:["value": Optional(2)], time:2020-12-10 11:16:29 +0000
        - (measurement: "demo", tags: ["type": "tuple"], fields: ["value": 3])

Success!
```