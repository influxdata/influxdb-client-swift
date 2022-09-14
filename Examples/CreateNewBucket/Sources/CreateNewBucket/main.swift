//
// Created by Jakub Bednář on 05/11/2020.
//

import ArgumentParser
import Foundation
import InfluxDBSwift
import InfluxDBSwiftApis

struct CreateNewBucket: AsyncParsableCommand {
    @Option(name: .shortAndLong, help: "New bucket name.")
    private var name: String

    @Option(name: .shortAndLong, help: "Duration bucket will retain data.")
    private var retention: Int64 = 3600

    @Option(name: .shortAndLong, help: "Specifies the organization name.")
    private var org: String

    @Option(name: .shortAndLong, help: "Authentication token.")
    private var token: String

    @Option(name: .shortAndLong, help: "HTTP address of InfluxDB.")
    private var url: String
}

extension CreateNewBucket {
    mutating func run() async throws {
        // Initialize Client and API
        let client = InfluxDBClient(url: url, token: token)
        let api = InfluxDB2API(client: client)

        let orgId = (try await api.organizationsAPI.getOrgs(org: org)!).orgs?.first?.id

        // Bucket configuration
        let request = PostBucketRequest(
                orgID: orgId!,
                name: name,
                retentionRules: [RetentionRule(type: RetentionRule.ModelType.expire, everySeconds: retention)])

        // Create Bucket
        let bucket = try await api.bucketsAPI.postBuckets(postBucketRequest: request)!

        // Create Authorization with permission to read/write created bucket
        let bucketResource = Resource(
                type: Resource.ModelType.buckets,
                id: bucket.id,
                orgID: orgId
        )

        // Authorization configuration
        let authorizationRequest = AuthorizationPostRequest(
                description: "Authorization to read/write bucket: \(name)",
                orgID: orgId!,
                permissions: [
                    Permission(action: Permission.Action.read, resource: bucketResource),
                    Permission(action: Permission.Action.write, resource: bucketResource)
                ])

        // Create Authorization
        let authorization =
                try await api.authorizationsAPI.postAuthorizations(authorizationPostRequest: authorizationRequest)!

        print("The bucket: '\(bucket.name)' is successfully created.")
        print("The following token could be use to read/write:")
        print("\t\(authorization.token!)")

        client.close()
    }
}
