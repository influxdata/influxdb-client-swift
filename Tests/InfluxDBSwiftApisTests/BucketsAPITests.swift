//
// Created by Jakub Bednář on 02/11/2020.
//

import InfluxDBSwift
@testable import InfluxDBSwiftApis
import XCTest

class BucketsAPITests: APIXCTestCase {
    override func setUp() {
        super.setUp()
        api.getBucketsAPI().getBuckets(limit: 100) { buckets, _ in
            buckets?
                    .buckets?
                    .filter { bucket in
                        bucket.name.hasSuffix("_TEST")
                    }.forEach { bucket in
                        self.api.getBucketsAPI().deleteBucketsID(bucketID: bucket.id!) { _, _ in
                        }
                    }
        }
    }

    func testCreateBucket() {
        let bucketName = generateName("bucket")
        let request = PostBucketRequest(orgID: Self.orgID, name: bucketName, retentionRules: [])

        var checker: (Bucket) -> Void = { response in
            XCTAssertNotNil(response.id)
            XCTAssertEqual(bucketName, response.name)
            XCTAssertEqual(Self.orgID, response.orgID)
            XCTAssertEqual(Bucket.ModelType.user, response.type)
            XCTAssertNotNil(response.links)
        }

        checkPost(api.getBucketsAPI().postBuckets, request, &checker)
    }
}
