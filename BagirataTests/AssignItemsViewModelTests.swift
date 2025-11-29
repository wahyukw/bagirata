//
//  AssignItemsViewModelTests.swift
//  BagirataTests
//
//  Created by Wahyu K on 30/11/2025.
//

import XCTest
@testable import Bagirata

final class AssignItemsViewModelTests: XCTestCase {
    
    var viewModel: AssignItemsViewModel!
    var testBill: Bill!
    var guest1: Guest!
    var guest2: Guest!
    var guest3: Guest!
    var item1: BillItem!
    var item2: BillItem!
    
    override func setUp(){
        super.setUp()
        
        guest1 = Guest(name: "John", avatarImg: "avatar1")
        guest2 = Guest(name: "Doe", avatarImg: "avatar2")
        guest3 = Guest(name: "Wahyu", avatarImg: "avatar3")
        
        item1 = BillItem(name: "Pizza", price: 20.0, assignedTo: [])
        item2 = BillItem(name: "Burger", price: 15.0, assignedTo: [])
        
        testBill = Bill(
            name: "Test Bill",
            taxAmount: 3.85,
            tipAmount: 5.0,
            guests: [guest1, guest2, guest3],
            items: [item1, item2]
        )
        
        viewModel = AssignItemsViewModel(bill: testBill)
    }
    
    override func tearDown() {
        viewModel = nil
        testBill = nil
        guest1 = nil
        guest2 = nil
        guest3 = nil
        item1 = nil
        item2 = nil
        
        super.tearDown()
    }
    
    func testInitialStateNoItemsAssigned(){
        XCTAssertFalse(viewModel.canCalculate)
        XCTAssertEqual(viewModel.unassignedItems.count, 2)
        XCTAssertNotNil(viewModel.validationMessage)
    }
    
    func testIsGuestAssigned() {
        XCTAssertFalse(viewModel.isGuestAssignedToItem(guest: guest1, item: item1))
    }
    
    func testToggleGuestOnAddsGuest(){
        //Arrange: Check if guest is not assigned initially
        XCTAssertFalse(viewModel.isGuestAssignedToItem(guest: guest1, item: item1))
        
        //Act: Toggle guest on
        viewModel.toggleGuestForItem(guest: guest1, item: item1)
        
        //Assert: Guest should now be assigned
        XCTAssertTrue(viewModel.isGuestAssignedToItem(guest: guest1, item: item1))
    }
    
    func testToggleGuestOffRemovesGuest(){
        //Arrange: Check if guest is assigned
        viewModel.toggleGuestForItem(guest: guest1, item: item1)
        XCTAssertTrue(viewModel.isGuestAssignedToItem(guest: guest1, item: item1))
        
        //Act: Toggle guest on
        viewModel.toggleGuestForItem(guest: guest1, item: item1)
        
        //Assert: Guest should now be assigned
        XCTAssertFalse(viewModel.isGuestAssignedToItem(guest: guest1, item: item1))
    }
    
    func testMultipleGuestsAssignedToOneItem(){
        //Act
        viewModel.toggleGuestForItem(guest: guest1, item: item1)
        viewModel.toggleGuestForItem(guest: guest2, item: item1)
        viewModel.toggleGuestForItem(guest: guest3, item: item1)
        
        //Assert
        XCTAssertTrue(viewModel.isGuestAssignedToItem(guest: guest1, item: item1))
        XCTAssertTrue(viewModel.isGuestAssignedToItem(guest: guest2, item: item1))
        XCTAssertTrue(viewModel.isGuestAssignedToItem(guest: guest3, item: item1))
    }
    
    func testGetAssignedGuestsCount(){
        //Arrange
        viewModel.toggleGuestForItem(guest: guest1, item: item1)
        viewModel.toggleGuestForItem(guest: guest2, item: item1)
        
        //Act & Assert
        XCTAssertEqual(viewModel.getAssignedGuestsCount(for: item1), 2)
        XCTAssertEqual(viewModel.getAssignedGuestsCount(for: item2), 0)
    }
    
    func testCanCalculateWhenAllItemsAssigned(){
        //Arrange
        XCTAssertFalse(viewModel.canCalculate)
        
        //Act
        viewModel.toggleGuestForItem(guest: guest1, item: item1)
        viewModel.toggleGuestForItem(guest: guest2, item: item2)
        
        //Assert
        XCTAssertTrue(viewModel.canCalculate)
        XCTAssertNil(viewModel.validationMessage)
    }
    
    func testUnassignedItemsReturnsCorrectly(){
        //Arrange
        viewModel.toggleGuestForItem(guest: guest1, item: item1)
        
        //Act
        let unassigned = viewModel.unassignedItems
        
        //Assert
        XCTAssertEqual(unassigned.count, 1)
        XCTAssertEqual(unassigned.first?.id, item2.id)
    }
}
