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
    
    @State private var authManager = AuthenticationManager()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Bill.self,
            BillItem.self,
            Guest.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do{
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        }catch{
            fatalError("Could not initialize ModelContainer: \(error.localizedDescription)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            Group{
                if authManager.isAuthenticated{
                    HomeView()
                        .modelContainer(sharedModelContainer)
                }
                else{
                    LoginView()
                }
            }
        }
        .environment(authManager)
    }
}
