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
    var taxAmount: String = ""
    var tipAmount: String = ""
    var billName: String = ""
    
    var subtotal: Double{
        items.reduce(0){$0 + $1.price}
    }
    
    var taxAmountDouble: Double {
        Double(taxAmount) ?? 0
    }
    
    var tipAmountDouble: Double {
        Double(tipAmount) ?? 0
    }
    
    var total: Double {
        subtotal + taxAmountDouble + tipAmountDouble
    }
    
    var canProceed: Bool {
        !items.isEmpty
    }
    
    func addItem(name: String, price: Double){
        
    }
    
    func removeItem(at index: Int){
        
    }
    func createBill() -> Bill {
        return Bill()
    }
}
