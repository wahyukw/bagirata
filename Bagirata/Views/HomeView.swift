//
//  ContentView.swift
//  Bagirata
//
//  Created by Wahyu K on 28/11/2025.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Bill.date, order: .reverse) private var bills: [Bill]
    
    @State private var showCreateBill = false
    
    var body: some View {
        NavigationStack(){
            ZStack{
                if bills.isEmpty{
                    EmptyStateView
                }else{
                    BillListView
                }
                
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        AddButton
                            .padding(.trailing, 40)
                            .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("My Bills")
            .navigationDestination(for: Bill.self) { bill in
                ResultsView(bill: bill, onComplete: { _ in })
            }
            .sheet(isPresented: $showCreateBill) {
                CreateBillView(onComplete: {bill in
                    modelContext.insert(bill)
                    showCreateBill = false
                })
            }
        }
    }
    
    private var EmptyStateView: some View{
        VStack(spacing: 12){
            Spacer()
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 64))
                .foregroundStyle(.gray)
            
            Text("No Bills Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Tap the + button to create your first bill")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Spacer()
            Spacer()
        }
    }
    
    private var BillListView: some View {
        List {
            ForEach(bills) { bill in
                ZStack(alignment: .leading) {
                    NavigationLink(value: bill) {
                        EmptyView()
                    }
                    .opacity(0)
                    
                    BillCardView(bill: bill)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        deleteBill(bill)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
    
    private var AddButton: some View{
        Button{
            showCreateBill = true
        }label:{
            Image(systemName: "plus")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(width: 60, height: 60)
                .background(.black)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
        }
    }
    
    private func deleteBill(_ bill: Bill){
        modelContext.delete(bill)
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Bill.self, inMemory: true)
}
