//
//  AssignItemsView.swift
//  Bagirata
//
//  Created by Wahyu K on 2/12/2025.
//

import SwiftUI

struct AssignItemsView: View {
    
    @Environment(BillState.self) private var billState
    
    @State private var viewModel: AssignItemsViewModel?
    
    var body: some View {
        VStack(spacing: 16){
            instructionsSection
            ScrollView(showsIndicators: false) {
                    itemsSection
            }
            calculateButton
        }
        .padding()
        .navigationTitle("Assign Items")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if viewModel == nil {
                viewModel = AssignItemsViewModel(bill: billState.bill)
            }
        }
    }
    
    private var instructionsSection: some View{
        VStack(alignment: .leading, spacing: 8) {
            Text("Assign guests to items")
                .font(.headline)
            Text("Tap to select who ordered each item. Items can be shared!")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            if let vm = viewModel {
                if !vm.canCalculate{
                    Label{
                        Text(vm.validationMessage ?? "")
                    } icon: {
                        Image(systemName: "exclamationmark.triangle.fill")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.orange)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var itemsSection: some View{
        LazyVStack(spacing: 16){
            if let vm = viewModel{
                ForEach(viewModel!.bill.items){ item in
                    ItemAssignmentCard(
                        item: item,
                        guests: vm.bill.guests,
                        viewModel: vm
                    )
                }
            }else {
                ProgressView("Loading...")
            }
            
        }
    }
    
    private var calculateButton: some View{
        NavigationLink(value: "results") {
            Text("Calculate Split")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background((viewModel?.canCalculate ?? false) ? Color.black : Color.gray)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(!(viewModel?.canCalculate ?? false))
        .simultaneousGesture(TapGesture().onEnded {
            if let vm = viewModel, vm.canCalculate {
                billState.bill = vm.bill
            }
        })
    }
}
