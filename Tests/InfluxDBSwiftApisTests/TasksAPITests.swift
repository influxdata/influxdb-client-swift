//
// Created by Jakub Bednář on 04/11/2020.
//

import InfluxDBSwift
@testable import InfluxDBSwiftApis
import XCTest

class TasksAPITests: APIXCTestCase {
    override func setUp() {
        super.setUp()
        api?.getTasksAPI().getTasks(limit: 100) { tasks, _ in
            tasks?
                    .tasks?
                    .filter { task in
                        task.name.hasSuffix("_TEST")
                    }.forEach { task in
                        self.api?.getTasksAPI().deleteTasksID(taskID: task.id) { _, _ in
                        }
                    }
        }
    }

    func testCreateTask() {
        let taskName = generateName("task")
        let flux = """
                option task = {
                    name: \"\(taskName)\",
                    every: 1h
                }

                from(bucket:\"my-bucket\") |> range(start: -1m) |> last()
                """
        let request = TaskCreateRequest(orgID: Self.orgID, flux: flux)

        var checker: (Task) -> Void = { response in
            XCTAssertNotNil(response.id)
            XCTAssertEqual(taskName, response.name)
            XCTAssertEqual(Self.orgID, response.orgID)
            XCTAssertEqual(flux, response.flux)
            XCTAssertEqual("1h", response.every)
            XCTAssertNotNil(response.links)
        }

        checkPost(api?.getTasksAPI().postTasks, request, &checker)
    }
}
