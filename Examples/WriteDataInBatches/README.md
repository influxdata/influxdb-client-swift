# WriteDataInBatches

How to use Combine to prepare batches for write into InfluxDB

## Prerequisites:
- macOS 11+
- Cloned examples:
   ```bash
   git clone git@github.com:influxdata/influxdb-client-swift.git
   cd Examples/WriteDataInBatches
   ```

## Sources:
- [Package.swift](/Examples/WriteDataInBatches/Package.swift)
- [main.swift](/Examples/WriteDataInBatches/Sources/WriteDataInBatches/main.swift)

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
1. Write data by:
   ```bash
   swift run write-data-in-batches --bucket my-bucket --org my-org --token my-token --url http://localhost:8086
   ```

## Expected output

```bash
Writing 500 items ...
 > success
Writing 500 items ...
 > success
Writing 500 items ...
 > success
Writing 500 items ...
 > success
Writing 500 items ...
 > success
Writing 500 items ...
 > success
Writing 500 items ...
 > success
Writing 452 items ...
 > success
Import finished!
```