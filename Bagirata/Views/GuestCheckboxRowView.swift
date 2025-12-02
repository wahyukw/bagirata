//
//  GuestChecboxRowView.swift
//  Bagirata
//
//  Created by Wahyu K on 2/12/2025.
//

import SwiftUI

struct GuestCheckboxRowView: View {
    
    let guest: Guest
    let item: BillItem
    let viewModel: AssignItemsViewModel
    
    private var isChecked: Bool{
        viewModel.isGuestAssignedToItem(guest: guest, item: item)
    }
    
    var body: some View {
        HStack(spacing: 12){
            Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                .font(.title3)
                .foregroundStyle(isChecked ? .blue : .gray)
            
            Image(guest.avatarImg)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
            
            Text(guest.name)
                .font(.body)
            
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture{
            viewModel.toggleGuestForItem(guest: guest, item: item)
        }
    }
}

