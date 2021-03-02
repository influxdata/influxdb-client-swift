//
// Created by Jakub Bednář on 04/11/2020.
//

import InfluxDBSwift
@testable import InfluxDBSwiftApis
import XCTest

class ScraperTargetsAPITests: APIXCTestCase {
    override func setUp() {
        super.setUp()
        api.scraperTargetsAPI.getScrapers { scrapers, _ in
            scrapers?
                    .configurations?
                    .filter { configuration in
                        if let name = configuration.name {
                            return name.hasSuffix("_TEST")
                        }
                        return false
                    }.forEach { configuration in
                        self.api.scraperTargetsAPI.deleteScrapersID(scraperTargetID: configuration.id!) { _, _ in
                        }
                    }
        }
    }

    func testCreateScraperTarget() {
        let scraperName = generateName("scraper")
        let request = ScraperTargetRequest(
                name: scraperName,
                type: ScraperTargetRequest.ModelType.prometheus,
                url: "http://localhost:8086",
                orgID: Self.orgID,
                bucketID: Self.bucketID)

        var checker: (ScraperTargetResponse) -> Void = { response in
            XCTAssertNotNil(response.id)
            XCTAssertEqual(scraperName, response.name)
            XCTAssertEqual(Self.orgID, response.orgID)
            XCTAssertEqual(Self.bucketID, response.bucketID)
            XCTAssertEqual(ScraperTargetResponse.ModelType.prometheus, response.type)
            XCTAssertNotNil(response.links)
        }

        checkPost(api.scraperTargetsAPI.postScrapers, request, &checker)
    }
}
