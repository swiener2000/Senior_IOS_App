//
//  drinkTests.swift
//  Tipsy_TellerTests
//
//  Created by Stephanie Wiener on 3/20/22.
//

import XCTest
@testable import Tipsy_Teller
class drinkTests: XCTestCase {

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


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testWine_tappingButton() {
        sut.wineButton?.sendActions(for: .touchUpInside)
    }
    
    func testBeer_tappingButton() {
        sut.beerButton.sendActions(for: .touchUpInside)
    }
    
    func testMalt_tappingButton() {
        sut.maltButton.sendActions(for: .touchUpInside)
    }
    
    func testLiqour_tappingButton() {
        sut.liquorButton.sendActions(for: .touchUpInside)
    }
    
    func testFavDrink_tappingButton() {
        sut.favDrinkButton.sendActions(for: .touchUpInside)
    }
    
    func testSize1_tappingButton() {
        sut.size1Button.sendActions(for: .touchUpInside)
    }
    
    func testSize2_tappingButton() {
        sut.size2Button.sendActions(for: .touchUpInside)
    }
    
    func testSize3_tappingButton() {
        sut.size3Button.sendActions(for: .touchUpInside)
    }
    
    func testSize4_tappingButton() {
        sut.size4Button.sendActions(for: .touchUpInside)
    }
}
