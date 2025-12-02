//
//  AddGuestsView.swift
//  Bagirata
//
//  Created by Moladin on 1/12/2025.
//

import SwiftUI

struct AddGuestsView: View {
    @State private var viewModel: GuestViewModel
    @Binding var navigationPath: NavigationPath
    let onComplete: (Bill) -> Void
    
    @State private var newGuestName = ""
    @State private var showError = false
    @State private var errorMessage = ""
    
    @Environment(\.dismiss) private var dismiss
    
    init(bill: Bill, navigationPath: Binding<NavigationPath>, onComplete: @escaping (Bill) -> Void) {
        _viewModel = State(initialValue: GuestViewModel(bill: bill))
        _navigationPath = navigationPath
        self.onComplete = onComplete
    }
    
    var body: some View {
        
        VStack(spacing: 12){
            instructionsSection
            addGuestSection
        }
        .padding()
        ScrollView(showsIndicators: false){
            VStack(spacing: 12){
                guestsListSection
            }
            .padding(.horizontal)
        }
        nextButton
            .padding()
        .navigationTitle("Add Guests")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Error", isPresented: $showError){
            Button("OK", role: .cancel){}
        }message: {
            Text(errorMessage)
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
            if let validationMsg = viewModel.validationMessage{
                Text(validationMsg)
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
    }
    
    private var guestsListSection: some View{
        VStack(alignment: .leading, spacing: 12) {
            if !viewModel.bill.guests.isEmpty{
                Text("Guests (\(viewModel.bill.guests.count))")
                    .font(.headline)
                
                ForEach(Array(viewModel.bill.guests.enumerated()), id: \.element.id) {index, guest in
                    HStack(spacing: 12){
                        Image(guest.avatarImg)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                        
                        Text(guest.name)
                            .font(.body)
                        
                        Spacer()
                        
                        Button(role: .destructive){
                            viewModel.removeGuest(at: index)
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
        Button{
            goToAssignItems()
        } label: {
            Text("Next: Assign Items")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(viewModel.canProceed ? Color.black : Color.gray)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(!viewModel.canProceed)
    }
    
    private var canAddGuest: Bool {
        viewModel.isNameValid(newGuestName)
    }
    
    private func addGuest() {
        let trimmedName = newGuestName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if viewModel.isNameDuplicate(trimmedName){
            errorMessage = "'\(trimmedName)' is already in the list"
            showError = true
            return
        }
        
        viewModel.addGuest(name: trimmedName)
        
        newGuestName = ""
    }
    
    private func goToAssignItems(){
        navigationPath.append(AssignItemsStep(bill: viewModel.bill))
    }
}

#Preview {
    let john = Guest(name: "John", avatarImg: "avatar1")
    let pizza = BillItem(name: "Pizza", price: 20.0, assignedTo: [])
    
    let bill = Bill(
        name: "Test Bill",
        taxAmount: 2.2,
        tipAmount: 5.0,
        guests: [],
        items: [pizza]
    )
    
    return NavigationStack {
        AddGuestsView(
            bill: bill,
            navigationPath: .constant(NavigationPath()),
            onComplete: { _ in }
        )
    }
}
