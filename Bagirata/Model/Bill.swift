//
//  Bill.swift
//  Bagirata
//
//  Created by Wahyu K on 28/11/2025.
//

import Foundation
import SwiftData

@Model
class Bill:Identifiable, Hashable{
    var id: UUID
    var name: String?
    var date: Date
    var taxAmount: Double
    var tipAmount: Double
    
    @Relationship(deleteRule: .cascade, inverse: \Guest.bill)
    var guests: [Guest]
    
    @Relationship(deleteRule: .cascade, inverse: \BillItem.bill)
    var items: [BillItem]
    
    //Sum of all item prices before tax and tip
    var subtotal: Double{
        items.reduce(0){$0 + $1.price}
    }
    //Sum of the bill including tax and tip
    var total: Double{
        subtotal+taxAmount+tipAmount
    }
    //Logic to check if items is empty, guest is empty, and each item have at least 1 assigned guest
    var canCalculate: Bool{
        !items.isEmpty &&
        !guests.isEmpty &&
        items.allSatisfy{$0.isAssigned}
    }
    //Returns the guests who are involved in this bill
    var activeGuests: [Guest]{
        guests.filter{ guest in
            items.contains{$0.assignedTo.contains(guest)}
        }
    }
    
    init(
        id: UUID = UUID(),
        name: String? = nil,
        date: Date = Date(),
        taxAmount: Double = 0,
        tipAmount: Double = 0,
        guests: [Guest] = [],
        items: [BillItem] = []
    ){
        self.id = id
        self.name = name
        self.date = date
        self.taxAmount = taxAmount
        self.tipAmount = tipAmount
        self.guests = guests
        self.items = items
    }
}
