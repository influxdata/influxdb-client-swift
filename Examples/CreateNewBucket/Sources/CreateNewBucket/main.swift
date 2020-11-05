//
// Created by Jakub Bednář on 05/11/2020.
//

import ArgumentParser
import Foundation
import InfluxDBSwift
import InfluxDBSwiftApis

struct CreateNewBucket: ParsableCommand {
    @Option(name: .shortAndLong, help: "New bucket name.")
    private var name: String

    @Option(name: .shortAndLong, help: "Duration bucket will retain data.")
    private var retention: Int = 3600

    @Option(name: .shortAndLong, help: "The ID of the organization.")
    private var orgId: String

    @Option(name: .shortAndLong, help: "Authentication token.")
    private var token: String

    @Option(name: .shortAndLong, help: "HTTP address of InfluxDB.")
    private var url: String

    public func run() {
        // Initialize Client and API
        let client = InfluxDBClient(url: url, token: token)
        let api = InfluxDB2API(client: client)

        // Bucket configuration
        let request = PostBucketRequest(
                orgID: self.orgId,
                name: self.name,
                retentionRules: [RetentionRule(type: RetentionRule.ModelType.expire, everySeconds: self.retention)])

        // Create Bucket
        api.getBucketsAPI().postBuckets(postBucketRequest: request) { bucket, error in
            // For error exit
            if let error = error {
                self.atExit(client: client, error: error)
            }

            if let bucket = bucket {
                // Create Authorization with permission to read/write created bucket
                let bucketResource = Resource(
                        type: Resource.ModelType.buckets,
                        id: bucket.id!,
                        orgID: self.orgId
                )
                // Authorization configuration
                let request = Authorization(
                        description: "Authorization to read/write bucket: \(self.name)",
                        orgID: self.orgId,
                        permissions: [
                            Permission(action: Permission.Action.read, resource: bucketResource),
                            Permission(action: Permission.Action.write, resource: bucketResource)
                        ])

                // Create Authorization
                api.getAuthorizationsAPI().postAuthorizations(authorization: request) { authorization, error in
                    // For error exit
                    if let error = error {
                        atExit(client: client, error: error)
                    }

                    // Print token
                    if let authorization = authorization {
                        let token = authorization.token!
                        print("The token: '\(token)' is authorized to read/write from/to bucket: '\(bucket.id!)'.")
                        atExit(client: client)
                    }
                }
            }
        }

        // Wait to end of script
        RunLoop.current.run()
    }

    private func atExit(client: InfluxDBClient, error: InfluxDBError? = nil) {
        // Dispose the Client
        client.close()
        // Exit script
        Self.exit(withError: error)
    }
}

CreateNewBucket.main()
