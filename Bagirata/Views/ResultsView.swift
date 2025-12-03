//
//  ResultsView.swift
//  Bagirata
//
//  Created by Wahyu K on 3/12/2025.
//

import SwiftUI

struct ResultsView: View {
    
    let bill: Bill
    let onComplete: (Bill) -> Void
    
    @State private var viewModel: ResultsViewModel?
    @State private var showShareSheet = false
    
    var body: some View {
        Group {
            if let vm = viewModel {
                if vm.hasError {
                    errorView(vm:vm, message: vm.errorMessage ?? "Unknown error")
                } else {
                    successView(vm: vm)
                }
            } else {
                ProgressView("Calculating...")
            }
        }
        .navigationTitle("Split Summary")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    onComplete(bill)
                }
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = ResultsViewModel(bill: bill)
            }
        }
    }
    
    private func successView(vm: ResultsViewModel) -> some View{
        ScrollView(showsIndicators: false){
            VStack(spacing: 24) {
                totalBillSection(vm: vm)
                guestSharesSection(vm: vm)
                shareButton
            }
            .padding()
        }
    }
    
    private func totalBillSection(vm: ResultsViewModel) -> some View{
        VStack(spacing: 8) {
            Text("Total Bill")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Text("$\(String(format:"%.2f", vm.totalBillAmount))")
                .font(.system(size: 48, weight: .bold))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func guestSharesSection(vm: ResultsViewModel) -> some View {
            VStack(spacing: 16) {
                ForEach(vm.guestShares.filter{$0.itemsSubtotal > 0}) { guestShare in
                    GuestShareCard(guestShare: guestShare)
                }
            }
        }
    
    private var shareButton: some View {
        Button {
            showShareSheet = true
        } label: {
            Label("Share Summary", systemImage: "square.and.arrow.up")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: [generateShareText()])
        }
    }
    
    private func errorView(vm: ResultsViewModel, message: String) -> some View{
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 64))
                .foregroundStyle(.orange)
            
            Text("Calculation Error")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button {
                vm.retryCalculation()
            } label: {
                Text("Retry")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding()
    }
    
    private func generateShareText() -> String {
        guard let vm = viewModel else { return "" }
        let activeShares = vm.guestShares.filter{$0.itemsSubtotal > 0}
        
        var text = "💰 Bill Split Summary\n\n"
        text += "Total: $\(String(format: "%.2f", vm.totalBillAmount))\n\n"
        
        for share in activeShares {
            text += "👤 \(share.guest.name)\n"
            
            for item in share.itemsOrdered {
                let isSplit = item.assignedTo.count > 1
                text += "   • \(item.name)"
                if isSplit {
                    text += " (split)"
                }
                text += "\n"
            }
    
            text += "   Subtotal: $\(String(format: "%.2f", share.itemsSubtotal))\n"
            text += "   Tax: $\(String(format: "%.2f", share.taxAmount))\n"
            text += "   Tip: $\(String(format: "%.2f", share.tipAmount))\n"
            text += "   Total: $\(String(format: "%.2f", share.totalOwed))\n\n"
        }
        
        return text
    }
    
    struct ShareSheet: UIViewControllerRepresentable {
        let items: [Any]
        
        func makeUIViewController(context: Context) -> UIActivityViewController {
            let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
            return controller
        }
        
        func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
    }
}

