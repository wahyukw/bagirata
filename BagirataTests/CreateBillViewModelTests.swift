//
//  CreateBillViewModel.swift
//  BagirataTests
//
//  Created by Wahyu K on 29/11/2025.
//

import XCTest
@testable import Bagirata

final class CreateBillViewModelTests: XCTestCase {

    var viewModel: CreateBillViewModel!
    
    override func setUp(){
        super.setUp()
        viewModel = CreateBillViewModel()
    }
    
    override func tearDown(){
        viewModel = nil
        super.tearDown()
    }
    
    func testInitialStateIsEmpty(){
        //Assert
        XCTAssertTrue(viewModel.items.isEmpty)
        XCTAssertEqual(viewModel.subtotal, 0)
        XCTAssertEqual(viewModel.total, 0)
        XCTAssertFalse(viewModel.canProceed)
        XCTAssertEqual(viewModel.taxAmount, 0)
    }
    
    func testAddItemIncreasesCount(){
        //Act
        viewModel.addItem(name: "Fries", price: 5.0)
        
        //Assert
        XCTAssertEqual(viewModel.items.count, 1)
        XCTAssertEqual(viewModel.items.first?.name, "Fries")
        XCTAssertEqual(viewModel.items.first?.price, 5.0)
    }
    
    func testSubtotalCalculateCorrectly(){
        //Arrange & Act
        viewModel.addItem(name: "Cola", price: 2.0)
        viewModel.addItem(name: "Sprite", price: 3.0)
        viewModel.addItem(name: "Burger", price: 7.5)
        
        //Assert
        XCTAssertEqual(viewModel.subtotal, 12.5)
    }
    
    func testTaxAutoCalculate(){
        //Arrange & Act
        viewModel.addItem(name: "Cola", price: 2.0)
        viewModel.addItem(name: "Sprite", price: 3.0)
        
        //Assert
        XCTAssertEqual(viewModel.taxAmount, 0.55, accuracy: 0.01)
    }
    
    func testTotalIncludesTaxAndTip(){
        //Arrange & Act
        viewModel.addItem(name: "Cola", price: 2.0)
        viewModel.addItem(name: "Sprite", price: 3.0)
        viewModel.tipAmount = "5.0"
        
        //Assert
        XCTAssertEqual(viewModel.total, 10.55, accuracy: 0.01)
    }
    
    func testRemoveItem(){
        //Arrange
        viewModel.addItem(name: "Cola", price: 2.0)
        viewModel.addItem(name: "Sprite", price: 3.0)
        viewModel.addItem(name: "Burger", price: 7.5)
        
        //Act
        viewModel.removeItem(at: 1)
        
        //Assert
        XCTAssertEqual(viewModel.items.count, 2)
        XCTAssertEqual(viewModel.items[0].name, "Cola")
        XCTAssertEqual(viewModel.items[1].name, "Burger")
    }
    
    func testCreateBill(){
        //Arrange
        let bill = Bill()
        
        viewModel.addItem(name: "Cola", price: 2.0)
        viewModel.addItem(name: "Sprite", price: 3.0)
        viewModel.tipAmount = "5.0"
        viewModel.billName = "Dinner at John's"
        
        //Act
        let updatedBill = viewModel.createBill(bill: bill)
        
        //Assert
        XCTAssertEqual(updatedBill.items.count, 2)
        XCTAssertEqual(updatedBill.items[0].name, "Cola")
        XCTAssertEqual(updatedBill.items[1].name, "Sprite")
        
        XCTAssertEqual(updatedBill.subtotal, 5.0)
        XCTAssertEqual(updatedBill.taxAmount, 0.55, accuracy: 0.01)
        XCTAssertEqual(updatedBill.tipAmount, 5.0)
        XCTAssertEqual(updatedBill.total, 10.55, accuracy: 0.01)
        
        XCTAssertEqual(updatedBill.name, "Dinner at John's")
        XCTAssertTrue(updatedBill.guests.isEmpty)
        
        XCTAssertEqual(updatedBill.date.timeIntervalSinceNow, 0, accuracy: 1.0)
    }
}
