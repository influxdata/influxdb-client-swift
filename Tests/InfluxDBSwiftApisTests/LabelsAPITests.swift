//
// Created by Jakub Bednář on 04/11/2020.
//

import InfluxDBSwift
@testable import InfluxDBSwiftApis
import XCTest

class LabelsAPITests: APIXCTestCase {
    override func setUp() {
        super.setUp()
        api.labelsAPI.getLabels { labels, _ in
            labels?
                    .labels?
                    .filter {label in
                        if let name = label.name {
                            return name.hasSuffix("_TEST")
                        }
                        return false
                    }
                    .forEach { label in
                        self.api.labelsAPI.deleteLabelsID(labelID: label.id!) { _, _ in
                        }
                    }
        }
    }

    func testCreateLabel() {
        let labelName = generateName("label")
        let request = LabelCreateRequest(orgID: Self.orgID, name: labelName)

        var checker: (LabelResponse) -> Void = { response in
            XCTAssertNotNil(response.label)
            XCTAssertNotNil(response.label?.id)
            XCTAssertEqual(Self.orgID, response.label?.orgID)
            XCTAssertEqual(labelName, response.label?.name)
            XCTAssertNotNil(response.links)
        }

        checkPost(api.labelsAPI.postLabels, request, &checker)
    }
}
