//
//  GuestShareCard.swift
//  Bagirata
//
//  Created by Wahyu K on 3/12/2025.
//

import SwiftUI

struct GuestShareCard: View {
    let guestShare: GuestShare
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(guestShare.guest.avatarImg)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                
                Text(guestShare.guest.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 4) {
                ForEach(guestShare.itemsOrdered) { item in
                    HStack {
                        Text("•")
                        Text(item.name)
                        if item.assignedTo.count > 1 {
                            Text("(split)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .font(.subheadline)
                }
            }
            
            Divider()
            
            // Breakdown
            VStack(spacing: 8) {
                BreakdownRow(label: "Subtotal", amount: guestShare.itemsSubtotal)
                BreakdownRow(label: "Tax", amount: guestShare.taxAmount)
                BreakdownRow(label: "Tip", amount: guestShare.tipAmount)
                
                Divider()
                
                HStack {
                    Text("Total")
                        .font(.headline)
                    Spacer()
                    Text("$\(String(format: "%.2f", guestShare.totalOwed))")
                        .font(.headline)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
