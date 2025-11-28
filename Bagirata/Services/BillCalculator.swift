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
        //Check if bill has no items
        guard !bill.items.isEmpty else {
            throw BillCalculationError.noItems
        }
        //Check if bill has no guests
        guard !bill.guests.isEmpty else {
            throw BillCalculationError.noGuests
        }
        //Check if item is unassigned
        guard bill.items.allSatisfy({$0.isAssigned}) else {
            throw BillCalculationError.unassignedItems
        }
        
        return []
    }
}
