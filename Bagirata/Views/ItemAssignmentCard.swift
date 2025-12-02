//
//  ItemAssignmentCard.swift
//  Bagirata
//
//  Created by Wahyu K on 2/12/2025.
//

import SwiftUI

struct ItemAssignmentCard: View {
    
    let item: BillItem
    let guests: [Guest]
    let viewModel: AssignItemsViewModel
    
    private var assignedCount: Int{
        viewModel.getAssignedGuestsCount(for: item)
    }
    
    private var isUnassigned: Bool{
        assignedCount == 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            HStack{
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(.headline)
                    Text("$\(String(format: "%.2f", item.price))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                
                if assignedCount > 1{
                    Text("Split \(assignedCount) ways")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
            }
            Divider()
            
            VStack(spacing: 8){
                ForEach(guests){guest in
                    GuestCheckboxRowView(
                        guest: guest,
                        item: item,
                        viewModel: viewModel
                    )
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isUnassigned ? Color.red.opacity(0.5) : Color.clear, lineWidth: 2)
        )
    }
}

