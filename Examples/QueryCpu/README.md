# QueryCpu

This is an example how to query data into sequence of `FluxRecord`. 
The Telegraf sends data from [CPU Input Plugin](https://github.com/influxdata/telegraf/blob/master/plugins/inputs/cpu/README.md) into InfluxDB 2.0.

## Prerequisites:
- Docker
- Cloned examples:
   ```bash
   git clone git@github.com:influxdata/influxdb-client-swift.git
   cd Examples/QueryCpu
   ```

## Sources:
- [Package.swift](/Examples/QueryCpu/Package.swift)
- [main.swift](/Examples/QueryCpu/Sources/QueryCpu/main.swift)

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
1. Start Telegraf as a source of data:
   ```bash
   docker run --rm \
      --name telegraf \
      --link influxdb_v2 \
      --detach \
      --env HOST_ETC=/hostfs/etc \
      --env HOST_PROC=/hostfs/proc \
      --env HOST_SYS=/hostfs/sys \
      --env HOST_VAR=/hostfs/var \
      --env HOST_RUN=/hostfs/run \
      --env HOST_MOUNT_PREFIX=/hostfs \
      --volume /:/hostfs:ro \
      --volume $PWD/telegraf.conf:/etc/telegraf/telegraf.conf:ro \
      telegraf
   ```
1. Start SwiftCLI by:
   ```bash
    docker run --rm \
      --link influxdb_v2 \
      --privileged \
      --interactive \
      --tty \
      --volume $PWD/../..:/client \
      --workdir /client/Examples/QueryCpu \
      swift:5.3 /bin/bash
   ```
1. Execute Query by:
   ```bash
   swift run query-cpu --org my-org --bucket my-bucket --token my-token --url http://influxdb_v2:8086
   ```
   
## Expected output

```bash
Query to execute:

from(bucket: "my-bucket")
    |> range(start: -10m)
    |> filter(fn: (r) => r["_measurement"] == "cpu")
    |> filter(fn: (r) => r["cpu"] == "cpu-total")
    |> filter(fn: (r) => r["_field"] == "usage_user" or r["_field"] == "usage_system")
    |> last()

Success response...

CPU usage:
        usage_system: 22.717622080683473
        usage_user: 61.46496815287725
```
