//
//  AssignItemsViewModel.swift
//  Bagirata
//
//  Created by Wahyu K on 30/11/2025.
//

import Foundation
import SwiftUI

@Observable
class AssignItemsViewModel{
    var bill: Bill
    
    var canCalculate: Bool {
        bill.items.allSatisfy{$0.isAssigned}
    }
    
    var unassignedItems: [BillItem]{
        bill.items.filter{!$0.isAssigned}
    }
    
    var validationMessage: String? {
        if !canCalculate{
            let count = unassignedItems.count
            return "\(count) item(s) need to be assigned"
        }
        return nil
    }
    
    init(bill: Bill){
        self.bill = bill
    }
    
    func toggleGuestForItem(guest: Guest, item: BillItem){
        //Find item index in the bill
        guard let index = bill.items.firstIndex(where: {$0.id == item.id}) else{return}
        
        //Check if guest is already assigned, if yes, then remove / toggle off, else append to assignedTo array
        if let guestIndex = bill.items[index].assignedTo.firstIndex(where: {$0.id == guest.id}){
                bill.items[index].assignedTo.remove(at: guestIndex)
        } else {
            bill.items[index].assignedTo.append(guest)
        }
    }
    
    func isGuestAssignedToItem(guest: Guest, item: BillItem) -> Bool {
        //Find the item in bill.items by ID
        guard let billItem = bill.items.first(where: {$0.id == item.id}) else{
            return false
        }
        //Check if the guest is in that item's assignedTo array
        return billItem.assignedTo.contains(where: {$0.id == guest.id})
    }
    
    func getAssignedGuestsCount(for item: BillItem) -> Int{
        guard let billItem = bill.items.first(where: {$0.id == item.id}) else {return 0}
        
        return billItem.assignedTo.count
    }
}
