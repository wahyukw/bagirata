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
        
        let johnShare = results.first{$0.guest.id == guest1.id}!
        XCTAssertEqual(johnShare.itemsSubtotal, 10.0)
        XCTAssertEqual(johnShare.taxAmount, 0.0)
        XCTAssertEqual(johnShare.tipAmount, 0.0)
        XCTAssertEqual(johnShare.totalOwed, 10.0)
        
        let doeShare = results.first{$0.guest.id == guest2.id}!
        XCTAssertEqual(doeShare.itemsSubtotal, 10.0)
        XCTAssertEqual(doeShare.taxAmount, 0.0)
        XCTAssertEqual(doeShare.tipAmount, 0.0)
        XCTAssertEqual(doeShare.totalOwed, 10.0)
    }
    
    func testUnequalSplit(){
        //Arrange: John orders $60, Doe orders $40, tax is $10
        let guest1 = Guest(name: "John")
        let guest2 = Guest(name: "Doe")
        
        let item1 = BillItem(name: "Steak",
                             price: 60.0,
                             assignedTo:[guest1]
        )
        let item2 = BillItem(name: "Pizza",
                             price: 40.0,
                             assignedTo:[guest2]
        )
        
        let bill = Bill(
            taxAmount: 10.0,
            tipAmount: 0,
            guests: [guest1, guest2],
            items: [item1, item2]
        )
        
        //Act
        let results = try! calculator.calculateSplit(for: bill)
        
        //Assert: John pays 60% of tax, Doe pays 40% of tax
        let johnShare = results.first{$0.guest.id == guest1.id}!
        XCTAssertEqual(johnShare.itemsSubtotal, 60.0)
        XCTAssertEqual(johnShare.taxAmount, 6.0, accuracy: 0.01)
        XCTAssertEqual(johnShare.totalOwed, 66.0, accuracy: 0.01)
        
        let doeShare = results.first{$0.guest.id == guest2.id}!
        XCTAssertEqual(doeShare.itemsSubtotal, 40.0)
        XCTAssertEqual(doeShare.taxAmount, 4.0, accuracy: 0.01)
        XCTAssertEqual(doeShare.totalOwed, 44.0, accuracy: 0.01)
    }
    
    func testTipSplitEqually(){
        //Arrange: John orders $60, Doe orders $40, tip is $20
        let guest1 = Guest(name: "John")
        let guest2 = Guest(name: "Doe")
        
        let item1 = BillItem(name: "Steak",
                             price: 60.0,
                             assignedTo:[guest1]
        )
        let item2 = BillItem(name: "Pizza",
                             price: 40.0,
                             assignedTo:[guest2]
        )
        
        let bill = Bill(
            taxAmount: 0,
            tipAmount: 20.0,
            guests: [guest1, guest2],
            items: [item1, item2]
        )
        
        //Act
        let results = try! calculator.calculateSplit(for: bill)
        
        //Assert
        let johnShare = results.first{$0.guest.id == guest1.id}!
        XCTAssertEqual(johnShare.tipAmount, 10.0)
        
        let doeShare = results.first{$0.guest.id == guest2.id}!
        XCTAssertEqual(doeShare.tipAmount, 10.0)
    }
    
    func testGuestWithNoItems(){
        //Arrange John and Doe order, Shaq orders nothing
        let john = Guest(name: "John")
        let doe = Guest(name:"Doe")
        let shaq = Guest(name: "Shaq")
        
        let item1 = BillItem(name: "Pizza",
                             price: 30.0,
                             assignedTo: [john]
        )
        let item2 = BillItem(name: "Soda",
                             price: 5.0,
                             assignedTo: [doe]
        )
        
        let bill = Bill(
            taxAmount: 5.0,
            tipAmount: 10.0,
            guests: [john, doe, shaq],
            items: [item1, item2]
        )
        
        //Act
        let results = try! calculator.calculateSplit(for: bill)
        
        //Assert: Shaq should have $0.0 owed
        XCTAssertEqual(results.count, 3)
        
        let shaqShare = results.first{$0.guest.id == shaq.id}!
        XCTAssertEqual(shaqShare.itemsSubtotal, 0.0)
        XCTAssertEqual(shaqShare.taxAmount, 0.0)
        XCTAssertEqual(shaqShare.tipAmount, 0.0)
        XCTAssertEqual(shaqShare.totalOwed, 0.0)
        XCTAssertTrue(shaqShare.didNotOrder)
    }
}
