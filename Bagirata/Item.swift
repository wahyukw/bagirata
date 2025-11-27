//
//  Item.swift
//  Bagirata
//
//  Created by Moladin on 28/11/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
