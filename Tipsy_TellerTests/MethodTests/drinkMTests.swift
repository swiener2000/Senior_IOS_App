//
//  drinkMTests.swift
//  Tipsy_TellerTests
//
//  Created by Stephanie Wiener on 3/20/22.
//

import XCTest
@testable import Tipsy_Teller

class drinkMTests: XCTestCase {

    var sut: DrinkViewController!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "DrinkView") as? DrinkViewController
        sut.loadViewIfNeeded()
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
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testBACCalc() {
        let weight = 162
        let r = 0.55
        let drinks = 1.0
        let BAC = 0.0
        let result = sut.bacCalc(weight: weight, r: r, drinks: drinks, BAC: BAC)
        XCTAssertEqual(result, 0.03460943255363226)
        
    }
}
