//
//  GuestShare.swift
//  Bagirata
//
//  Created by Wahyu K on 28/11/2025.
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
        itemsOrdered: [BillItem]
    ){
        self.id = id
        self.guest = guest
        self.itemsSubtotal = itemsSubtotal
        self.taxAmount = taxAmount
        self.tipAmount = tipAmount
        self.totalOwed = itemsSubtotal + taxAmount + tipAmount
        self.itemsOrdered = itemsOrdered
    }
}
