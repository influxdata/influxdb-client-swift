# InvokableScripts

This is an example how to use Invokable scripts Cloud API to create custom endpoints that query data.
> :warning: Invokable Scripts are supported only in InfluxDB Cloud, currently there is no support in InfluxDB OSS.

## Prerequisites:
- Docker
- Cloned examples:
   ```bash
   git clone git@github.com:influxdata/influxdb-client-swift.git
   cd Examples/InvokableScripts
   ```

## Sources:
- [Package.swift](/Examples/InvokableScripts/Package.swift)
- [InvokableScripts.swift](/Examples/InvokableScripts/Sources/InvokableScripts/InvokableScripts.swift)

## How to test:
1. Start SwiftCLI by:
   ```bash
    docker run --rm \
      --privileged \
      --interactive \
      --tty \
      --volume $PWD/../..:/client \
      --workdir /client/Examples/InvokableScripts \
      swift:5.7 /bin/bash
   ```
1. Run Example by:
   ```bash
   swift run invokable-scripts --org my-org --bucket my-bucket --token my-token --url https://us-west-2-1.aws.cloud2.influxdata.com
   ```
   
## Expected output

```bash
------- Create -------

▿ InfluxDBSwift.Script
  ▿ id: Optional("0945186f3962f000")
    - some: "0945186f3962f000"
  - name: "my_script_1650951739.551672"
  ▿ description: Optional("my first try")
    - some: "my first try"
  - orgID: "04014de4ed590000"
  - script: "from(bucket: params.bucket_name) |> range(start: -30d) |> limit(n:2)"
  ▿ language: Optional(InfluxDBSwift.ScriptLanguage.flux)
    - some: InfluxDBSwift.ScriptLanguage.flux
  - url: nil
  ▿ createdAt: Optional(2022-04-26 05:42:19 +0000)
    ▿ some: 2022-04-26 05:42:19 +0000
      - timeIntervalSinceReferenceDate: 672644539.621
  ▿ updatedAt: Optional(2022-04-26 05:42:19 +0000)
    ▿ some: 2022-04-26 05:42:19 +0000
      - timeIntervalSinceReferenceDate: 672644539.621

------- Update -------

▿ InfluxDBSwift.Script
  ▿ id: Optional("0945186f3962f000")
    - some: "0945186f3962f000"
  - name: "my_script_1650951739.551672"
  ▿ description: Optional("my updated description")
    - some: "my updated description"
  - orgID: "04014de4ed590000"
  - script: "from(bucket: params.bucket_name) |> range(start: -30d) |> limit(n:2)"
  ▿ language: Optional(InfluxDBSwift.ScriptLanguage.flux)
    - some: InfluxDBSwift.ScriptLanguage.flux
  - url: nil
  ▿ createdAt: Optional(2022-04-26 05:42:19 +0000)
    ▿ some: 2022-04-26 05:42:19 +0000
      - timeIntervalSinceReferenceDate: 672644539.621
  ▿ updatedAt: Optional(2022-04-26 05:42:19 +0000)
    ▿ some: 2022-04-26 05:42:19 +0000
      - timeIntervalSinceReferenceDate: 672644539.8399999

------- List -------

Scripts:
        0945186f3962f000: my_script_1650951739.551672: my updated description

------- Invoke to FluxRecords -------

        Prague: 25.3
        New York: 24.3

------- Invoke to Raw -------

RAW output:

 ,result,table,_start,_stop,_time,_value,_field,_measurement,location
,_result,1,2022-03-27T05:42:20.589649766Z,2022-04-26T05:42:20.589649766Z,2022-03-28T07:59:52Z,25.3,temperature,my_measurement,Prague
,_result,2,2022-03-27T05:42:20.589649766Z,2022-04-26T05:42:20.589649766Z,2022-03-28T07:59:52Z,24.3,temperature,my_measurement,New York


------- Delete -------

Successfully deleted script: 'my_script_1650951739.551672'

```
