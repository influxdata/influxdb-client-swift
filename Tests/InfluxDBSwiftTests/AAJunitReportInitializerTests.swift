//
// Created by Jakub Bednář on 11/12/2020.
//

import Foundation

@testable import InfluxDBSwift
import SwiftTestReporter
import XCTest

class AAJunitReportInitializerTest: XCTestCase {
    override class func setUp() {
        _ = TestObserver()
        super.setUp()
    }

    // https://github.com/allegro/swift-junit/issues/12#issuecomment-725264315
    func testInit() {}
}
