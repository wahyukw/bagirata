//
//  AddGuestsView.swift
//  Bagirata
//
//  Created by Wahyu K on 1/12/2025.
//

import SwiftUI

struct AddGuestsView: View {
    
    @Environment(BillState.self) private var billState
    
    @State private var viewModel: GuestViewModel?
    @State private var newGuestName = ""
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 12){
            instructionsSection
            addGuestSection
            ScrollView(showsIndicators: false){
                VStack{
                    guestsListSection
                }
            }
            nextButton
        }
        .padding()
        .navigationTitle("Add Guests")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Error", isPresented: $showError){
            Button("OK", role: .cancel){}
        }message: {
            Text(errorMessage)
        }
        .onAppear {
            viewModel = GuestViewModel(bill: billState.bill)
        }
        .onDisappear {
            if let vm = viewModel {
                billState.bill = vm.bill
            }
        }
    }
    
    private var instructionsSection: some View{
        VStack(alignment: .leading, spacing: 8) {
            Text("Who's splitting this bill?")
                .font(.headline)
            Text("Add everyone who will be paying")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var addGuestSection: some View{
        VStack(alignment: .leading, spacing: 12){
            HStack{
                TextField("Guest name (e.g., John)", text: $newGuestName)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit{
                        addGuest()
                    }
                Button{
                    addGuest()
                }label:{
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(canAddGuest ? .blue : .gray)
                }
                .disabled(!canAddGuest)
            }
            if let vm = viewModel, let validationMsg = vm.validationMessage{
                Text(validationMsg)
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
    }
    
    private var guestsListSection: some View{
        VStack(alignment: .leading, spacing: 12) {
            if let vm = viewModel, !vm.bill.guests.isEmpty{
                Text("Guests (\(vm.bill.guests.count))")
                    .font(.headline)
                
                ForEach(Array(vm.bill.guests.enumerated()), id: \.element.id) {index, guest in
                    HStack(spacing: 12){
                        Image(guest.avatarImg)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                        
                        Text(guest.name)
                            .font(.body)
                        
                        Spacer()
                        
                        Button(role: .destructive){
                            vm.removeGuest(at: index)
                        }label:{
                            Image(systemName: "trash")
                                .foregroundStyle(.red)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
    }
    
    private var nextButton: some View{
        NavigationLink(value: "assignItems") {
            Text("Next: Assign Items")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background((viewModel?.canProceed ?? false) ? Color.black : Color.gray)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(!(viewModel?.canProceed ?? false))
        .simultaneousGesture(TapGesture().onEnded {
            if let vm = viewModel, vm.canProceed {
                // Update shared bill state
                billState.bill = vm.bill
            }
        })
    }
    
    private var canAddGuest: Bool {
        viewModel?.isNameValid(newGuestName) ?? false
    }
    
    private func addGuest() {
        guard let vm = viewModel else { return }
        
        let trimmedName = newGuestName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if vm.isNameDuplicate(trimmedName){
            errorMessage = "'\(trimmedName)' is already in the list"
            showError = true
            return
        }
        
        vm.addGuest(name: trimmedName)
        
        newGuestName = ""
    }
}
