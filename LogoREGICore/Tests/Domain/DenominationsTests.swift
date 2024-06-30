//
//  DenominationsTests.swift
//  cafelogos-posTests
//
//  Created by ygates on 2023/08/18.
//

import XCTest
@testable import cafelogos_pos

final class DenominationsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        let denomi = Denominations(denominations: [
            Denomination(amount: 10000, quantity: 5), // 50000yen
            Denomination(amount: 5000, quantity: 2), // 10000yen
            Denomination(amount: 1000, quantity: 10), // 10000yen
            Denomination(amount: 500, quantity: 20), // 10000yen
            Denomination(amount: 100, quantity: 50), // 5000yen
            Denomination(amount: 50, quantity: 50), // 2500yen
            Denomination(amount: 10, quantity: 50), // 500yen
            Denomination(amount: 5, quantity: 50), // 250yen
            Denomination(amount: 1, quantity: 50) // 50yen
        ])
        let result = denomi.total()
        XCTAssertEqual(result, 88300)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
