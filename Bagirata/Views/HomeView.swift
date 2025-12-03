//
//  ContentView.swift
//  Bagirata
//
//  Created by Wahyu K on 28/11/2025.
//

import SwiftUI


struct HomeView: View {
    @State private var bills: [Bill] = []
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
                    bills.append(bill)
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
    
    private var BillListView: some View{
        ScrollView(showsIndicators: false){
            LazyVStack(spacing: 16){
                ForEach(bills){ bill in
                    NavigationLink(value: bill) {
                        BillCardView(bill: bill)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
            .padding(.bottom, 80)
        }
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
}

#Preview {
    HomeView()
}
