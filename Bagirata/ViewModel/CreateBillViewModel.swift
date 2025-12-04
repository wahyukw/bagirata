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
    var bill: Bill
    var taxRate: Double = 0.11
    var tipAmount: String = ""
    var billName: String = ""
    
    init(bill: Bill){
        self.bill = bill
        self.load()
    }
    
    var subtotal: Double{
        bill.items.reduce(0){$0 + $1.price}
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
        !bill.items.isEmpty &&
        (tipAmount.isEmpty || Double(tipAmount) != nil)
    }
    
    func addItem(name: String, price: Double){
        let newItem = BillItem(name: name, price: price)
        bill.items.append(newItem)
    }
    
    func removeItem(at index: Int){
        bill.items.remove(at: index)
    }
    func saveBill(){
        bill.name = self.billName.isEmpty ? nil : self.billName
        bill.taxAmount = self.taxAmount
        bill.tipAmount = self.tipAmountDouble
    }
    func load() {
        let loadedName = bill.name ?? ""
        
        if loadedName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.billName = "Unnamed Bill"
        } else {
            self.billName = loadedName
        }
        
        self.tipAmount = bill.tipAmount > 0 ? String(bill.tipAmount) : ""
    }
}

