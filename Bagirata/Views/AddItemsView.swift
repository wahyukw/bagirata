//
//  AddItemsView.swift
//  Bagirata
//
//  Created by Wahyu K on 1/12/2025.
//

import SwiftUI

struct AddItemsView: View {
    @Environment(BillState.self) private var billState
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel: CreateBillViewModel = .init()
    @State private var newItemName = ""
    @State private var newItemPrice = ""
    @State private var billName = ""
    
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack(spacing: 18){
                billNameSection
                itemsListSection
                addItemSection
                billSummarySection
                nextButton
            }
            .padding()
        }
        .navigationTitle("Add Items")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .cancellationAction){
                Button{
                    dismiss()
                }label:{
                    Text("Cancel")
                        .foregroundStyle(.red)
                }
            }
        }
        .onAppear {
            viewModel.load(bill: billState.bill)
        }
    }
    
    private var billNameSection: some View {
        VStack(alignment: .leading, spacing: 8){
            Text("Bill Name (Optional)")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
            
            TextField("e.g. Dinner at John's", text: $billName)
                .textFieldStyle(.roundedBorder)
                .onChange(of: billName){ _, newValue in
                    viewModel.billName =  newValue
                }
        }
    }
    
    private var itemsListSection: some View{
        VStack(alignment: .leading, spacing: 12) {
            if(!viewModel.items.isEmpty){
                Text("Items")
                    .font(.headline)
            }
            
            ForEach(Array(viewModel.items.enumerated()), id: \.element.id){index, item in
                HStack{
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.name)
                            .font(.body)
                        Text("$\(String(format: "%.2f", item.price))")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    
                    Button(role: .destructive){
                        viewModel.removeItem(at: index)
                    }label: {
                        Image(systemName: "trash")
                            .foregroundStyle(.red)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    private var addItemSection: some View{
        VStack(alignment: .leading, spacing: 12) {
            Text("Add New Item")
                .font(.headline)
            
            VStack(spacing: 12){
                TextField("Item name (e.g. Pizza)", text: $newItemName)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Price", text: $newItemPrice)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                
                Button{
                    addItem()
                }label:{
                    Label("Add Item", systemImage: "plus.circle.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(canAddItem ? Color.blue : Color.gray)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .disabled(!canAddItem)
                Divider()
            }
        }
    }
    
    private var billSummarySection: some View{
        VStack(spacing: 12){
            HStack{
                Text("Subtotal")
                    .font(.body)
                Spacer()
                Text("$\(String(format: "%.2f", viewModel.subtotal))")
                    .font(.body)
            }
            HStack{
                Text("Tax (11%)")
                    .font(.body)
                Spacer()
                Text("$\(String(format: "%.2f", viewModel.taxAmount))")
                    .font(.body)
            }
            
            HStack{
                Text("Tip")
                    .font(.body)
                Spacer()
                TextField("$0.00", text: $viewModel.tipAmount)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 100)
                    .textFieldStyle(.roundedBorder)
            }
            Divider()
            HStack{
                Text("Total")
                    .font(.headline)
                Spacer()
                Text("$\(String(format: "%.2f", viewModel.total))")
                    .font(.headline)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var nextButton: some View{
        NavigationLink(value: "addGuests") {
            Text("Next: Add Guests")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(viewModel.canProceed ? Color.black : Color.gray)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(!viewModel.canProceed)
        .simultaneousGesture(TapGesture().onEnded {
            if viewModel.canProceed {
                billState.bill = viewModel.createBill(bill: billState.bill)
            }
        })
    }
    
    private var canAddItem: Bool{
        !newItemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !newItemPrice.isEmpty &&
        Double(newItemPrice) != nil &&
        Double(newItemPrice)! > 0
    }
    
    private func addItem(){
        guard let price = Double(newItemPrice) else {return}
        
        viewModel.addItem(name: newItemName, price: price)
        
        newItemName = ""
        newItemPrice = ""
    }
}

