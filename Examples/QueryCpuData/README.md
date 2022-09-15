# QueryCpuData

This is an example how to query data into `CSV`.
The Telegraf sends data from [CPU Input Plugin](https://github.com/influxdata/telegraf/blob/master/plugins/inputs/cpu/README.md) into InfluxDB 2.x.

## Prerequisites:
- Docker
- Cloned examples:
   ```bash
   git clone git@github.com:influxdata/influxdb-client-swift.git
   cd Examples/QueryCpuData
   ```

## Sources:
- [Package.swift](/Examples/QueryCpuData/Package.swift)
- [QueryCpuData.swift](/Examples/QueryCpuData/Sources/QueryCpuData/QueryCpuData.swift)

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
      --workdir /client/Examples/QueryCpuData \
      swift:5.7 /bin/bash
   ```
1. Execute Query by:
   ```bash
   swift run query-cpu-data --org my-org --bucket my-bucket --token my-token --url http://influxdb_v2:8086
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

InfluxDB response: #datatype,string,long,dateTime:RFC3339,dateTime:RFC3339,dateTime:RFC3339,double,string,string,string,string
#group,false,false,true,true,false,false,true,true,true,true
#default,_result,,,,,,,,,
,result,table,_start,_stop,_time,_value,_field,_measurement,cpu,host
,,0,2022-09-15T07:58:34.225194426Z,2022-09-15T08:08:34.225194426Z,2022-09-15T08:08:30Z,0.10020040081752843,usage_system,cpu,cpu-total,2a2946671fe7
,,1,2022-09-15T07:58:34.225194426Z,2022-09-15T08:08:34.225194426Z,2022-09-15T08:08:30Z,0.20040080148924608,usage_user,cpu,cpu-total,2a2946671fe7

```
