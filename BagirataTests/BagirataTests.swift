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
        
        //Act & Assert: Should throw noItems error
        XCTAssertThrowsError(try calculator.calculateSplit(for: bill)) { error in
            XCTAssertEqual(error as? BillCalculationError, .noItems)
        }
    }
    
    func testCalculationNoGuests(){
        //Arrange: Create bill with items but NO guests
        let item1 = BillItem(name: "Pizza", price: 20.0)
        let item2 = BillItem(name: "Soda", price: 5.0)
        
        let bill = Bill(
            taxAmount: 5.0,
            tipAmount: 10.0,
            guests: [], //Bill with empty guests
            items: [item1, item2]
        )
        
        //Act & Assert: Should throw noGuests error
        XCTAssertThrowsError(try calculator.calculateSplit(for: bill)){error in
            XCTAssertEqual(error as? BillCalculationError, .noGuests)
        }
    }
}
