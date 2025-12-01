//
//  CreateBillView.swift
//  Bagirata
//
//  Created by Wahyu K on 1/12/2025.
//

import SwiftUI

struct CreateBillView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var navigationPath = NavigationPath()
    let onComplete: (Bill) -> Void
    
    var body: some View {
        NavigationStack(path: $navigationPath){
            AddItemsView(navigationPath: $navigationPath,
                         onComplete: onComplete
            )
            .navigationDestination(for: Bill.self){ bill in
                AddGuestsView(bill: bill,
                              navigationPath: $navigationPath,
                              onComplete: onComplete
                )
            }
        }
    }
}

#Preview {
    CreateBillView(onComplete: { _ in })
}
