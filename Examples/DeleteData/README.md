# DeleteData

This is an example how to delete data with specified predicate. 
See delete predicate syntax in InfluxDB docs - [delete-predicate](https://docs.influxdata.com/influxdb/cloud/reference/syntax/delete-predicate/).

## Prerequisites:
- Docker
- Cloned examples:
   ```bash
   git clone git@github.com:bonitoo-io/influxdb-client-swift.git
   cd Examples/DeleteData
   ```

## Sources:
- [Package.swift](/Examples/DeleteData/Package.swift)
- [main.swift](/Examples/DeleteData/Sources/DeleteData/main.swift)

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
1. Write following data into InfluxDB:
   ```bash
   docker exec influxdb_v2 influx write -b my-bucket -o my-org -t my-token \
   "
   server,provider=aws,production=no,app=gitlab cpu_usage=98,mem_usage=68
   server,provider=azure,production=yes,app=balancer cpu_usage=63,mem_usage=54
   server,provider=azure,production=no,app=jira cpu_usage=12,mem_usage=13
   server,provider=azure,production=yes,app=db cpu_usage=84,mem_usage=75
   server,provider=aws,production=yes,app=web cpu_usage=16,mem_usage=42
   "
   ```
1. Start SwiftCLI by:
   ```bash
    docker run --rm \
      --link influxdb_v2 \
      --privileged \
      --interactive \
      --tty \
      --volume $PWD/../..:/client \
      --workdir /client/Examples/DeleteData \
      swift:5.3 /bin/bash
   ```
1. Delete date where tag `production` is `no`:
   ```bash
   swift run delete-data --org my-org --bucket my-bucket --token my-token --url http://influxdb_v2:8086 \
      --predicate "_measurement=\"server\" AND production=\"no\""
   ```
   
## Expected output

```bash
Deleted data by predicate:

        DeletePredicateRequest(start: 1970-01-01 00:00:00 +0000, stop: 2021-01-07 09:03:24 +0000, predicate: Optional("_measurement=\"server\" AND production=\"no\""))

Remaining data after delete:

        azure,production=yes,app=balancer
        azure,production=yes,app=db
        aws,production=yes,app=web
```
