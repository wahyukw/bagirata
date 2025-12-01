//
//  BillItem.swift
//  Bagirata
//
//  Created by Wahyu K on 28/11/2025.
//

import Foundation

struct BillItem: Identifiable, Equatable, Hashable {
    let id: UUID
    var name: String
    var price: Double
    var assignedTo: [Guest]
    
    var isAssigned:Bool{
        !assignedTo.isEmpty
    }
    
    init(
        id: UUID = UUID(),
        name: String,
        price: Double,
        assignedTo:[Guest] = []
    ){
        self.id = id
        self.name = name
        self.price = price
        self.assignedTo = assignedTo
    }
}
