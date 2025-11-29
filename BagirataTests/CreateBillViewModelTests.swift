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
    }
    
    func testAddItemIncreasesCount(){
        //Act
        viewModel.addItem(name: "Fries", price: 5.0)
        
        //Assert
        XCTAssertEqual(viewModel.items.count, 1)
        XCTAssertEqual(viewModel.items.first?.name, "Fries")
        XCTAssertEqual(viewModel.items.first?.price, 5.0)
    }
}
