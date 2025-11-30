//
//  ResultsViewModelTests.swift
//  BagirataTests
//
//  Created by Wahyu K on 30/11/2025.
//

import XCTest
@testable import Bagirata

final class ResultsViewModelTests: XCTestCase {
    
    var viewModel: ResultsViewModel!
    var testBill: Bill!
    var mockCalculator: MockBillCalculator!
    
    override func setUp() {
        super.setUp()
        
        let john = Guest(name: "John", avatarImg: "avatar1")
        let doe = Guest(name: "Doe", avatarImg: "avatar2")
        
        let pizza = BillItem(name: "Pizza", price: 20.0, assignedTo: [john, doe])
        let burger = BillItem(name:"Burger", price: 15.0, assignedTo: [john])
        
        testBill = Bill(
            name: "Test Bill",
            taxAmount: 3.85,
            tipAmount: 5.0,
            guests: [john, doe],
            items: [pizza, burger]
        )
        
        mockCalculator = MockBillCalculator()
    }
    
    override func tearDown() {
        viewModel = nil
        testBill = nil
        mockCalculator = nil
        super.tearDown()
    }
    
    func testCalculateResultsOnInit(){
        viewModel = ResultsViewModel(bill: testBill, calculator: mockCalculator)
        
        XCTAssertEqual(mockCalculator.calculateCallCount, 1)
    }
    
    func testSuccessCalculation(){
        viewModel = ResultsViewModel(bill: testBill, calculator: mockCalculator)
        
        //Assert
        XCTAssertEqual(viewModel.guestShares.count, 2)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.hasError)
    }
    
    func testCalculationErrorSetsErrorMessage(){
        //Arrange
        mockCalculator.shouldThrowError = true
        
        //Act
        viewModel = ResultsViewModel(bill: testBill, calculator: mockCalculator)
        
        //Assert
        XCTAssertTrue(viewModel.guestShares.isEmpty)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.hasError)
    }
    
    func testTotalBillAmountReturnsCorrectValue(){
        viewModel = ResultsViewModel(bill: testBill, calculator: mockCalculator)
        
        //Assert
        let expectedTotal = testBill.subtotal + testBill.taxAmount + testBill.tipAmount
        XCTAssertEqual(viewModel.totalBillAmount, expectedTotal, accuracy: 0.01)
    }
    
    func testRetryCalculationCallsCalculatorAgain(){
        //Arrange
        viewModel = ResultsViewModel(bill: testBill, calculator: mockCalculator)
        let initialCallCount = mockCalculator.calculateCallCount
        
        //Act
        viewModel.retryCalculation()
        
        //Assert
        XCTAssertEqual(mockCalculator.calculateCallCount, initialCallCount + 1)
    }
    
    func testRealCalculatorWhenNoneProvided(){
        viewModel = ResultsViewModel(bill: testBill)
        
        //Assert
        XCTAssertFalse(viewModel.guestShares.isEmpty)
        XCTAssertNil(viewModel.errorMessage)
    }
}

class MockBillCalculator: BillCalculatorProtocol{
    var shouldThrowError = false
    var calculateCallCount = 0
    
    func calculateSplit(for bill: Bill) throws -> [GuestShare] {
        calculateCallCount += 1
        
        if shouldThrowError{
            throw BillCalculationError.unassignedItems
        }
        
        return bill.guests.map{ guest in
            GuestShare(guest: guest,
                       itemsSubtotal: 10.0,
                       taxAmount: 1.0,
                       tipAmount: 2.5,
                       itemsOrdered: []
            )
        }
    }
}
