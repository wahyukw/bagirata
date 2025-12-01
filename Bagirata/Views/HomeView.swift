//
//  ContentView.swift
//  Bagirata
//
//  Created by Wahyu K on 28/11/2025.
//

import SwiftUI


struct HomeView: View {
    @State private var bills: [Bill] = []
    @State private var navigationPath = NavigationPath()
    @State private var showCreateBill = false
    
    var body: some View {
        NavigationStack(path: $navigationPath){
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
            /*.navigationDestination(for: Bill.self){ bill in
                ResultsView(bill: bill, navigationPath: $navigationPath)
            }*/
            .sheet(isPresented: $showCreateBill) {
                CreateBillView(onComplete: {bill in
                    bills.append(bill)
                    showCreateBill = false
                })
            }
    }
        .onAppear{
            loadDummyData()
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
                BillCardView(bill: bill)
                    .onTapGesture {
                        //todo navigate to bill summary
                    }
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

private func loadDummyData(){
    // Create dummy bills for testing
    let john = Guest(name: "John", avatarImg: "avatar1")
    let sarah = Guest(name: "Sarah", avatarImg: "avatar2")
    let mike = Guest(name: "Mike", avatarImg: "avatar3")
    let emma = Guest(name: "Emma", avatarImg: "avatar4")
    
    let pizza = BillItem(name: "Caesar Salad", price: 12.50, assignedTo: [john, sarah])
    let burger = BillItem(name: "Cheeseburger", price: 16.00, assignedTo: [john])
    let tea = BillItem(name: "Iced Tea", price: 3.50, assignedTo: [sarah])
    
    bills = [
        Bill(
            name: "Dinner at Restaurant",
            date: Date().addingTimeInterval(-86400 * 10), // 10 days ago
            taxAmount: 15.68,
            tipAmount: 20.0,
            guests: [john, sarah, mike, emma],
            items: [pizza, burger, tea]
        ),
        Bill(
            name: "Lunch with Team",
            date: Date().addingTimeInterval(-86400 * 12), // 12 days ago
            taxAmount: 8.95,
            tipAmount: 15.0,
            guests: [john, sarah, mike, emma, emma, emma],
            items: [pizza, burger]
        ),
        Bill(
            name: "Coffee Meeting",
            date: Date().addingTimeInterval(-86400 * 15), // 15 days ago
            taxAmount: 2.48,
            tipAmount: 5.0,
            guests: [john, sarah],
            items: [tea]
        )
    ]
}
}

#Preview {
    HomeView()
}
