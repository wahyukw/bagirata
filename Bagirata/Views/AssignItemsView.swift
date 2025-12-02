//
//  AssignItemsView.swift
//  Bagirata
//
//  Created by Wahyu K on 2/12/2025.
//

import SwiftUI

struct AssignItemsView: View {
    
    @State private var viewModel: AssignItemsViewModel
    @Binding var navigationPath: NavigationPath
    let onComplete: (Bill) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    init(bill: Bill, navigationPath: Binding<NavigationPath>, onComplete: @escaping (Bill) -> Void){
        _viewModel = State(initialValue: AssignItemsViewModel(bill: bill))
        _navigationPath = navigationPath
        self.onComplete = onComplete
    }
    
    var body: some View {
        instructionsSection
            .padding()
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16){
                itemsSection
            }
            .padding(.horizontal)
        }
        calculateButton
            .padding()
        .navigationTitle("Assign Items")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var instructionsSection: some View{
        VStack(alignment: .leading, spacing: 8) {
            Text("Assign guests to items")
                .font(.headline)
            Text("Tap to select who ordered each item. Items can be shared!")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            if !viewModel.canCalculate{
                Label{
                    Text(viewModel.validationMessage ?? "")
                } icon: {
                    Image(systemName: "exclamationmark.triangle.fill")
                }
                .font(.subheadline)
                .foregroundStyle(.orange)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var itemsSection: some View{
        LazyVStack(spacing: 16){
            ForEach(viewModel.bill.items){ item in
                ItemAssignmentCard(
                    item: item,
                    guests: viewModel.bill.guests,
                    viewModel: viewModel
                )
            }
        }
    }
    
    private var calculateButton: some View{
        Button{
            calculateSplit()
        } label: {
            Text("Calculate Split")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(viewModel.canCalculate ? Color.black : Color.gray)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(!viewModel.canCalculate)
    }
    
    private func calculateSplit(){
        navigationPath.append(viewModel.bill)
    }
}

#Preview {
    let john = Guest(name: "John", avatarImg: "avatar1")
    let sarah = Guest(name: "Sarah", avatarImg: "avatar2")
    
    let pizza = BillItem(name: "Pizza", price: 20.0, assignedTo: [])
    let burger = BillItem(name: "Burger", price: 15.0, assignedTo: [])
    
    let bill = Bill(
        name: "Test Bill",
        taxAmount: 3.85,
        tipAmount: 5.0,
        guests: [john, sarah],
        items: [pizza, burger]
    )
    
    return NavigationStack {
        AssignItemsView(
            bill: bill,
            navigationPath: .constant(NavigationPath()),
            onComplete: { _ in }
        )
    }
}
