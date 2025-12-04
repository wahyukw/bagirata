//
//  BagirataApp.swift
//  Bagirata
//
//  Created by Wahyu K on 28/11/2025.
//

import SwiftUI
import SwiftData

@main
struct BagirataApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: Bill.self)
    }
}
