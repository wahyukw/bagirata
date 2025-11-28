//
//  GuestShare.swift
//  Bagirata
//
//  Created by Moladin on 28/11/2025.
//

import Foundation

struct GuestShare:Identifiable{
    let id: UUID
    let guest: Guest
    let itemsSubtotal: Double
    let taxAmount: Double
    let tipAmount: Double
    let totalOwed: Double
    let itemsOrdered: [BillItem]
    
    var didNotOrder: Bool {
        itemsOrdered.isEmpty
    }
    
    init(
        id: UUID = UUID(),
        guest: Guest,
        itemsSubtotal: Double,
        taxAmount: Double,
        tipAmount: Double,
        totalOwed: Double,
        itemsOrdered: [BillItem]
    ){
        self.id = id
        self.guest = guest
        self.itemsSubtotal = itemsSubtotal
        self.taxAmount = taxAmount
        self.tipAmount = tipAmount
        self.totalOwed = totalOwed
        self.itemsOrdered = itemsOrdered
    }
}
