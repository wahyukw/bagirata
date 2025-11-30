//
//  ResultsViewModel.swift
//  Bagirata
//
//  Created by Wahyu K on 30/11/2025.
//

import Foundation
import SwiftUI

@Observable
class ResultsViewModel {
    var bill: Bill
    var guestShares: [GuestShare] = []
    var errorMessage: String?
    
    private let calculator: BillCalculatorProtocol
    
    var hasError: Bool{
        errorMessage != nil
    }
    
    var totalBillAmount: Double {
        bill.total
    }
    
    init(bill: Bill, calculator: BillCalculatorProtocol = BillCalculator()){
        self.bill = bill
        self.calculator = calculator
        calculateResults()
    }
    
    func calculateResults(){
        do{
            guestShares = try calculator.calculateSplit(for: bill)
            errorMessage = nil
        } catch let error as BillCalculationError{
            errorMessage = error.userErrorMessage
        } catch{
            errorMessage = "An unexpected error occurred"
            guestShares = []
        }
    }
    
    func retryCalculation(){
        calculateResults()
    }
}
