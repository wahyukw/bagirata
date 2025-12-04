//
//  BillItem.swift
//  Bagirata
//
//  Created by Wahyu K on 28/11/2025.
//

import Foundation
import SwiftData

@Model
class BillItem: Identifiable, Equatable, Hashable {
    var id: UUID
    var name: String
    var price: Double
    
    @Relationship(deleteRule: .nullify)
    var assignedTo: [Guest]
    
    var bill: Bill?
    
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
