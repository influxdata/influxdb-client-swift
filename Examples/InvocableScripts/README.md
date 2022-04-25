# InvocableScripts

This is an example how to use Invocable scripts Cloud API to create custom endpoints that query data.
> :warning: Invocable Scripts are supported only in InfluxDB Cloud, currently there is no support in InfluxDB OSS.

## Prerequisites:
- Docker
- Cloned examples:
   ```bash
   git clone git@github.com:influxdata/influxdb-client-swift.git
   cd Examples/InvocableScripts
   ```

## Sources:
- [Package.swift](/Examples/InvocableScripts/Package.swift)
- [InvocableScripts.swift](/Examples/InvocableScripts/Sources/InvocableScripts/InvocableScripts.swift)

## How to test:
1. Start SwiftCLI by:
   ```bash
    docker run --rm \
      --privileged \
      --interactive \
      --tty \
      --volume $PWD/../..:/client \
      --workdir /client/Examples/InvocableScripts \
      swift:5.6 /bin/bash
   ```
1. Run Example by:
   ```bash
   swift run invocable-scripts --org my-org --bucket my-bucket --token my-token --url https://us-west-2-1.aws.cloud2.influxdata.com
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
