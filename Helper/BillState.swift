//
//  BillState.swift
//  Bagirata
//
//  Created by Wahyu K on 3/12/2025.
//

import Foundation
import SwiftUI

@Observable
class BillState{
    var bill: Bill
    
    init() {
        self.bill = Bill()
    }
}
