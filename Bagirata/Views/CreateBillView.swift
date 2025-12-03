//
//  CreateBillView.swift
//  Bagirata
//
//  Created by Wahyu K on 1/12/2025.
//

import SwiftUI

struct CreateBillView: View {
    @State private var billState = BillState()
    
    let onComplete: (Bill) -> Void
    
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path){
            AddItemsView()
            .navigationDestination(for: String.self){ destination in
                switch destination {
                case "addGuests":
                    AddGuestsView()
                case "assignItems":
                    AssignItemsView()
                case "results":
                    ResultsView(
                        bill: billState.bill,
                        onComplete: { finalBill in
                            onComplete(finalBill)
                            path = NavigationPath()
                        }
                    )
                default:
                    EmptyView()
                }
            }
        }
        .environment(billState)
    }
}
