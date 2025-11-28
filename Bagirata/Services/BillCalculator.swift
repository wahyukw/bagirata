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
        
        //Calculate when all checks pass
        var guestShares: [GuestShare] = []
        
        for guest in bill.guests{
            //Filter items in bill where it's assigned to each guest
            let guestItems = bill.items.filter{$0.assignedTo.contains(guest)}
            //Calculate the subtotal for each guest
            var guestSubtotal = 0.0
            //Check for each item in the item, how many is assigned to the item. Then add the subtotal for each guest
            for item in guestItems {
                let shareCount = Double(item.assignedTo.count)
                guestSubtotal += item.price / shareCount
            }
            
            //Calculate the tax for each guest based on the proportion of their subtotal item.
            //If the guest takes 30% of the bill subtotal, then they should get 30% of the tax
            let guestTax = bill.subtotal > 0 ? bill.taxAmount * (guestSubtotal / bill.subtotal) : 0
            
            //Calculate each guest tip (equal split among active guests)
            let activeGuestCount = Double(bill.activeGuests.count)
            let guestTip = activeGuestCount > 0 ? bill.tipAmount / activeGuestCount : 0
            
            //Finally calculate each guest's share
            let share = GuestShare(guest: guest,
                                   itemsSubtotal: guestSubtotal,
                                   taxAmount: guestTax,
                                   tipAmount: guestTip,
                                   itemsOrdered: guestItems
            )
            guestShares.append(share)
        }
        return guestShares
    }
}
