//
//  BillCalculationError.swift
//  Bagirata
//
//  Created by Wahyu K on 28/11/2025.
//

import Foundation

enum BillCalculationError: Error, Equatable{
    case unassignedItems
    case noGuests
    case noItems
    case invalidAmounts
}

extension BillCalculationError{
    var userErrorMessage: String{
        switch self{
        case .noItems:
            return "Please add at least one item befoer calculating"
        case .noGuests:
            return "Please add at least one guest before calculating"
        case .unassignedItems:
            return "Please assign all items to guests"
        case .invalidAmounts:
            return "Some amounts are invalid. Please check your entries"
        }
    }
}
