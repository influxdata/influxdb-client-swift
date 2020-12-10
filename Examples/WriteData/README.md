# WriteData

This is an example how to write data with different type of records.

How to test:
1. Start InfluxDB 2.0 by Docker:
    ```bash
    docker run --name influxdb_v2 -d -p "8086:8086" quay.io/influxdb/influxdb:v2.0.2
    ```
1. Navigate to http://localhost:8086/ and configure InfluxDB 2.0 
1. Find a name of your organization, a name of your bucket and your token:
    - https://docs.influxdata.com/influxdb/v2.0/organizations/view-orgs/
    - https://docs.influxdata.com/influxdb/v2.0/organizations/buckets/view-buckets/
    - https://docs.influxdata.com/influxdb/v2.0/security/tokens/view-tokens/
1. Write data by:
```bash
swift run write-data --bucket my-bucket --org my-org --token my-token --url http://localhost:8086
```
