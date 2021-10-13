# InfluxDBStatus

This is an example how to check status of InfluxDB.

## Prerequisites:
- Docker
- Cloned examples:
   ```bash
   git clone git@github.com:influxdata/influxdb-client-swift.git
   cd Examples/InfluxDBStatus
   ```

## Sources:
- [Package.swift](/Examples/InfluxDBStatus/Package.swift)
- [main.swift](/Examples/InfluxDBStatus/Sources/InfluxDBStatus/main.swift)


## How to test:
1. Start InfluxDB:
    ```bash
    docker run --rm \
      --name influxdb_v2 \
      --detach \
      --publish 8086:8086 \
      influxdb:latest
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
      --workdir /client/Examples/InfluxDBStatus \
      swift:5.3 /bin/bash
   ```
1. Check status of InfluxDB by:
   ```bash
   swift run influxdb-status --token my-token --url http://influxdb_v2:8086
   ```
## Expected output

```bash
The bucket: 'new-bucket' is successfully created.
The following token could be use to read/write:
        224axj_OaOOVIaEnSQgx2GTrrt18ZqUATS1I0Hsha3M7Bbbsn_yX9EiXTMnlq5aHz-f8h9iNcRJGd1_ImAD7fA==
```