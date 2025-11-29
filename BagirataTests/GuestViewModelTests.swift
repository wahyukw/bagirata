//
//  GuestViewModelTests.swift
//  BagirataTests
//
//  Created by Moladin on 29/11/2025.
//

import XCTest
@testable import Bagirata

final class GuestViewModelTests: XCTestCase {

    var viewModel: GuestViewModel!
    var testBill: Bill!
    
    override func setUp() {
        super.setUp()
        
        let item1 = BillItem(name: "Pizza", price: 20.0)
        let item2 = BillItem(name: "Burger", price: 10.0)
        
        testBill = Bill(
            name: "Test Bill",
            taxAmount: 3.3,
            tipAmount: 5.0,
            guests: [],
            items: [item1, item2]
        )
        
        viewModel = GuestViewModel(bill: testBill)
    }
    
    override func tearDown() {
        viewModel = nil
        testBill = nil
        super.tearDown()
    }

    func testInitialStateHasNoGuests(){
        XCTAssertTrue(viewModel.bill.guests.isEmpty)
        XCTAssertFalse(viewModel.canProceed)
        XCTAssertNotNil(viewModel.validationMessage)
    }
    
    func testIsNameValidEmptyString(){
        XCTAssertFalse(viewModel.isNameValid(""))
        XCTAssertFalse(viewModel.isNameValid("\n"))
        XCTAssertFalse(viewModel.isNameValid("    "))
    }
    
    func testValidName(){
        XCTAssertTrue(viewModel.isNameValid("  Bob  "))
        XCTAssertTrue(viewModel.isNameValid("Alice"))
        XCTAssertTrue(viewModel.isNameValid("A "))
    }
    
    func testDuplicateName(){
        //Arrange
        viewModel.addGuest(name: "John")
        viewModel.addGuest(name: "Doe")
        
        //Act & Assert
        XCTAssertTrue(viewModel.isNameDuplicate("John"))
        XCTAssertTrue(viewModel.isNameDuplicate("john"))
        XCTAssertTrue(viewModel.isNameDuplicate("  john  "))
    }
    
    func testUniqueName() {
        // Arrange
        viewModel.addGuest(name: "John")
        
        // Act & Assert
        XCTAssertFalse(viewModel.isNameDuplicate("Wahyu"))
        XCTAssertFalse(viewModel.isNameDuplicate("Bob"))
    }
    
    func testAddGuestWithValidName() {
        // Arrange
        let guessCount = viewModel.bill.guests.count
        
        // Act
        viewModel.addGuest(name: "John")
        
        // Assert
        XCTAssertEqual(viewModel.bill.guests.count, guessCount + 1)
        XCTAssertEqual(viewModel.bill.guests.last?.name, "John")
        XCTAssertNotNil(viewModel.bill.guests.last?.avatarImg)
    }
    
    func testRemoveGuest() {
        // Arrange
        viewModel.addGuest(name: "John")
        viewModel.addGuest(name: "Doe")
        viewModel.addGuest(name: "Wahyu")
        
        // Act
        viewModel.removeGuest(at: 1)
        
        // Assert
        XCTAssertEqual(viewModel.bill.guests.count, 2)
        XCTAssertEqual(viewModel.bill.guests[0].name, "John")
        XCTAssertEqual(viewModel.bill.guests[1].name, "Wahyu")
    }
}
