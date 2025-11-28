//
//  BillCalculator.swift
//  Bagirata
//
//  Created by Wahyu K on 28/11/2025.
//

import Foundation

//Protocol for testing
protocol BillCalculatorProtocol{
    func calculateSplit(for bill: Bill) throws -> [GuestShare]
}

class BillCalculator:BillCalculatorProtocol{
    func calculateSplit(for bill: Bill) throws -> [GuestShare] {
        guard !bill.items.isEmpty else {
            throw BillCalculationError.noItems
        }
        
        return []
    }
}
