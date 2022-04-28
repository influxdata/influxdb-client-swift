# AsyncAwait

This is an example how to use `async/await` with the InfluxDB client.

## Prerequisites:
- Docker
- Cloned examples:
   ```bash
   git clone git@github.com:influxdata/influxdb-client-swift.git
   cd Examples/AsyncAwait
   ```

## Sources:
- [Package.swift](/Examples/AsyncAwait/Package.swift)
- [AsyncAwait.swift](/Examples/AsyncAwait/Sources/AsyncAwait/AsyncAwait.swift)

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
      --workdir /client/Examples/AsyncAwait \
      swift:5.6 /bin/bash
   ```
1. Use `async/await` with `WriteAPI`, `QueryAPI` and `BucketsAPI`:
   ```bash
   swift run async-await --bucket my-bucket --org my-org --token my-token --url http://influxdb_v2:8086
   ```
   
## Expected output

```bash
Written data:
 > Optional("demo,type=point value=2i")
Query results:
 > value: 2
Buckets:
 > Optional("10c59301e9077c50"): my-bucket
 > Optional("552d1011d2cdab2d"): _tasks
 > Optional("a1a02f67f7189b89"): _monitoring
```
