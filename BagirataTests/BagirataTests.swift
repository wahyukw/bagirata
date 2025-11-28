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
    
    func testCalculationItemsUnassigned(){
        //Arrange: Create bill with items but not guests assigned to the item
        let guest1 = Guest(name: "John")
        let guest2 = Guest(name: "Doe")
        
        let item1 = BillItem(name: "Pizza", price: 20.0, assignedTo: [])
        let item2 = BillItem(name: "Soda", price: 5.0, assignedTo: [])
        
        let bill = Bill(
            taxAmount: 5.0,
            tipAmount: 10.0,
            guests: [guest1, guest2],
            items: [item1, item2]
            )
        
        //Act & Assert: Should throw unassignedItems error
        XCTAssertThrowsError(try calculator.calculateSplit(for: bill)){error in
            XCTAssertEqual(error as? BillCalculationError, .unassignedItems)
        }
    }
    
    func testSimpleEqualSplit(){
        //Arrange: $20 item split, no tax, no tip
        let guest1 = Guest(name: "John")
        let guest2 = Guest(name: "Doe")
        
        let item = BillItem(name: "Pizza",
                            price: 20.0,
                            assignedTo: [guest1, guest2]
        )
        
        let bill = Bill(
            taxAmount: 0,
            tipAmount: 0,
            guests: [guest1, guest2],
            items: [item]
        )
        //Act
        let results = try! calculator.calculateSplit(for: bill)
        
        //Assert: Each guest should owe $10
        XCTAssertEqual(results.count, 2)
        
        let aliceShare = results.first{$0.guest.id == guest1.id}!
        XCTAssertEqual(aliceShare.itemsSubtotal, 10.0)
        XCTAssertEqual(aliceShare.taxAmount, 0.0)
        XCTAssertEqual(aliceShare.tipAmount, 0.0)
        XCTAssertEqual(aliceShare.totalOwed, 10.0)
        
        let bobShare = results.first{$0.guest.id == guest2.id}!
        XCTAssertEqual(bobShare.itemsSubtotal, 10.0)
        XCTAssertEqual(bobShare.taxAmount, 0.0)
        XCTAssertEqual(bobShare.tipAmount, 0.0)
        XCTAssertEqual(bobShare.totalOwed, 10.0)
    }
}
