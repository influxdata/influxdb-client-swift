# CreateNewBucket

This is an example how to create new bucket with permission to write

How to test:
1. Start InfluxDB 2.0 by Docker:
    ```console
    docker run --name influxdb_v2 -d -p "8086:8086" quay.io/influxdb/influxdb:v2.0.2
    ```
1. Navigate to http://localhost:8086/ and configure InfluxDB 2.0 
1. Find the id of your organization and your token:
    - https://docs.influxdata.com/influxdb/v2.0/organizations/view-orgs/
    - https://docs.influxdata.com/influxdb/v2.0/security/tokens/view-tokens/
1. Create new bucket by:
   ```console
   swift run create-new-bucket --name new-bucket --org-id my-org-id --token my-token --url http://localhost:8086
   ```
