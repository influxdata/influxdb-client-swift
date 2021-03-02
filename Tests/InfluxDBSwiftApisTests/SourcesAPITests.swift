//
// Created by Jakub Bednář on 04/11/2020.
//

import InfluxDBSwift
@testable import InfluxDBSwiftApis
import XCTest

class SourcesAPITests: APIXCTestCase {
    override func setUp() {
        super.setUp()
        api.sourcesAPI.getSources { sources, _ in
            sources?
                    .sources?
                    .filter { source in
                        if let name = source.name {
                            return name.hasSuffix("_TEST")
                        }
                        return false
                    }.forEach { source in
                        self.api.sourcesAPI.deleteSourcesID(sourceID: source.id!) { _, _ in
                        }
                    }
        }
    }

    func testCreateSource() {
        let sourceName = generateName("source")
        let request = Source(
                orgID: Self.orgID,
                name: sourceName,
                type: Source.ModelType.v1,
                url: "http://localhost:8086")

        var checker: (Source) -> Void = { response in
            XCTAssertNotNil(response.id)
            XCTAssertEqual(sourceName, response.name)
            XCTAssertEqual(Self.orgID, response.orgID)
            XCTAssertEqual(Source.ModelType.v1, response.type)
            XCTAssertEqual("http://localhost:8086", response.url)
            XCTAssertNotNil(response.links)
        }

        checkPost(api.sourcesAPI.postSources, request, &checker)
    }
}
