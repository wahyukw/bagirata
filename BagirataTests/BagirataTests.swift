//
//  BagirataTests.swift
//  BagirataTests
//
//  Created by Wahyu K on 28/11/2025.
//

import XCTest
@testable import Bagirata

class BagirataTests: XCTestCase {

    var calculator: BillCalculator!
    
    override func setUp(){
        super.setUp()
        calculator = BillCalculator()
    }
    
    override func tearDown(){
        calculator = nil
        super.tearDown()
    }

    func testCalculationWhenNoItems(){
        //Arrange: Create empty bill
        let guest1 = Guest(name: "John")
        let guest2 = Guest(name: "Doe")
        
        let bill = Bill(
            taxAmount: 5.0,
            tipAmount: 10.0,
            guests: [guest1, guest2],
            items: []
        )
        
        //Act & Assert
        XCTAssertThrowsError(try calculator.calculateSplit(for: bill)) { error in
            XCTAssertEqual(error as? BillCalculationError, .noItems)
        }
    }
}
