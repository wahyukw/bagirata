//
//  Guest.swift
//  Bagirata
//
//  Created by Wahyu K on 28/11/2025.
//

import Foundation

struct Guest: Identifiable, Hashable, Equatable {
    let id: UUID
    
    var name: String
    var avatarImg: String
    
    init(
        id: UUID = UUID(),
        name: String,
        avatarImg: String = "defaultAvatar"
    ){
        self.id = id
        self.name = name
        self.avatarImg = avatarImg
    }
}

