//
//  ChaliceTests.swift
//  ChaliceTests
//
//  Created by Shaun Anderson on 20/8/18.
//  Copyright © 2018 Shaun Anderson. All rights reserved.
//

import XCTest
@testable import Chalice
import CoreData

class ChaliceTests: XCTestCase {


    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    ///
    /// Test getting the "Default" ruleset. can also be used to get the "Template" ruleset
    ///
    func testGetDefaultRuleset() {
        
        var testRuleset: ResponseData
        
        if let url = Bundle.main.url(forResource: "Default", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(ResponseData.self, from: data)
                    testRuleset = jsonData
                    // Check if name is correct
                    XCTAssertEqual(testRuleset.Title, "Default" , "Name is not correct")
                    // Check if card amount is correct (13)
                    XCTAssertEqual(testRuleset.Cards.count, 13)
                    testGenerateDeck(ruleset: testRuleset)
                } catch {
                    print("error:\(error)")
                }
        }
        

    }
    
    ///
    /// Test generation of deck from the Default JSON file
    ///
    func testGenerateDeck(ruleset: ResponseData) {
        
        var tempDeck = [Card]()
        var index: Int = 0
        for i in 0...3 {
            for j in 0...ruleset.Cards.count-1 {
                var newCard: Card = ruleset.Cards[j]
                newCard.suit = SuitType.allValues[i]
                tempDeck.append(newCard)
                index += 1
            }
        }
        
        // Check if number of cards is correct (52).
        XCTAssertEqual(tempDeck.count, 52)
    }
    
}
