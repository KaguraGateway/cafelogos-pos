//
//  Date.swift
//  cafelogos-posTests
//
//  Created by ygates on 2023/10/11.
//

import XCTest

final class Date: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let formatter = ISO8601DateFormatter()
        XCTAssertNotNil(formatter.date(from: "2018-09-18T02:00:00Z"))
        XCTAssertNotNil(formatter.date(from: "2023-10-11T00:24:40+00:00"))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
