//
//  CreateBillViewModel.swift
//  Bagirata
//
//  Created by Wahyu K on 29/11/2025.
//

import Foundation
import SwiftUI

@Observable
class CreateBillViewModel{
    var items: [BillItem] = []
    var taxRate: Double = 0.11
    var tipAmount: String = ""
    var billName: String = ""
    
    var subtotal: Double{
        items.reduce(0){$0 + $1.price}
    }
    
    var taxAmount: Double {
        subtotal*taxRate
    }
    
    var tipAmountDouble: Double {
        Double(tipAmount) ?? 0
    }
    
    var total: Double {
        subtotal + taxAmount + tipAmountDouble
    }
    
    var canProceed: Bool {
        !items.isEmpty
    }
    
    func addItem(name: String, price: Double){
        let newItem = BillItem(name: name, price: price)
        items.append(newItem)
    }
    
    func removeItem(at index: Int){
        items.remove(at: index)
    }
    func createBill() -> Bill {
        return Bill(
            name: billName.isEmpty ? nil : billName,
            date: Date(),
            taxAmount: taxAmount,
            tipAmount: tipAmountDouble,
            guests: [],
            items: items
        )
    }
}
