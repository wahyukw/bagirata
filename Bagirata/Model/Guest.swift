//
//  Guest.swift
//  Bagirata
//
//  Created by Wahyu K on 28/11/2025.
//

import Foundation
import SwiftData

@Model
class Guest: Identifiable, Hashable, Equatable {
    var id: UUID
    var name: String
    var avatarImg: String
    
    var bill: Bill?
    
    init(
        id: UUID = UUID(),
        name: String,
        avatarImg: String = "avatar1"
    ){
        self.id = id
        self.name = name
        self.avatarImg = avatarImg
    }
}

