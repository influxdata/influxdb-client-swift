//
// Created by Jakub Bednář on 04/11/2020.
//

import InfluxDBSwift
@testable import InfluxDBSwiftApis
import XCTest

class VariablesAPITests: APIXCTestCase {
    override func setUp() {
        super.setUp()
        api.getVariablesAPI().getVariables { variables, _ in
            variables?
                    .variables?
                    .filter { variable in
                        variable.name.hasSuffix("_TEST")
                    }.forEach { variable in
                        self.api.getVariablesAPI().deleteVariablesID(variableID: variable.id!) { _, _ in
                        }
                    }
        }
    }

    func testCreateVariable() {
        let variableName = generateName("variable")
        let request = Variable(
                orgID: Self.orgID,
                name: variableName,
                arguments: VariableProperties(
                        type: VariableProperties.ModelType.map,
                        values: ["key1": "value1", "key2": "value2"]))

        var checker: (Variable) -> Void = { response in
            XCTAssertNotNil(response.id)
            XCTAssertEqual(Self.orgID, response.orgID)
            XCTAssertEqual(variableName, response.name)
            XCTAssertEqual(["key1": "value1", "key2": "value2"], response.arguments.values)
            XCTAssertNotNil(response.links)
        }

        checkPost(api.getVariablesAPI().postVariables, request, &checker)
    }
}
