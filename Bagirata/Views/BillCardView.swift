//
//  BillCardView.swift
//  Bagirata
//
//  Created by Wahyu K on 1/12/2025.
//

import SwiftUI

struct BillCardView: View {
    let bill: Bill
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            HStack(alignment: .top) {
                Text((bill.name?.trimmingCharacters(in: .whitespacesAndNewlines)).flatMap { $0.isEmpty ? nil : $0 } ?? "Unnamed Bill")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("$\(String(format: "%.2f", bill.total))")
                    .font(.headline)
                    .fontWeight(.bold)
            }
            
            HStack{
                Label{
                    Text(bill.date.formatted(date: .abbreviated, time: .omitted))
                }icon:{
                    Image(systemName: "calendar")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                
                Spacer()
                
                Label{
                    Text("\(bill.guests.count) people")
                }icon:{
                    Image(systemName: "person.2")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y:2)
    }
}

#Preview {
    let john = Guest(name: "John", avatarImg: "avatar1")
    let sarah = Guest(name: "Sarah", avatarImg: "avatar2")
    let pizza = BillItem(name: "Pizza", price: 20.0, assignedTo: [john])
    
    let bill = Bill(
        name: "Dinner at Restaurant",
        date: Date(),
        taxAmount: 15.68,
        tipAmount: 20.0,
        guests: [john, sarah],
        items: [pizza]
    )
    
    return BillCardView(bill: bill)
        .padding()
}

