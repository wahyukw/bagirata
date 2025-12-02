//
//  GuestViewModel.swift
//  Bagirata
//
//  Created by Wahyu K on 29/11/2025.
//

import Foundation
import SwiftUI

@Observable
class GuestViewModel{
    var  bill: Bill
    
    var guests: [Guest] {
        bill.guests
    }
    
    var canProceed: Bool {
        !bill.guests.isEmpty
    }
    
    var validationMessage: String? {
        if bill.guests.isEmpty{
            return "Please add at least one guest"
        }
        return nil
    }
    
    init(bill: Bill){
        self.bill = bill
    }
    
    func addGuest(name: String){
        guard isNameValid(name) else { return }
        guard !isNameDuplicate(name) else { return }
        
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let guest = Guest(
            name: trimmedName,
            avatarImg: getRandomAvatar()
        )
        
        bill.guests.append(guest)
    }
    
    func removeGuest(at index: Int){
        let removedGuest = bill.guests[index]
        
        bill.guests.remove(at: index)
        
        for i in 0..<bill.items.count{
            bill.items[i].assignedTo.removeAll{ $0.id == removedGuest.id }
        }
    }
    
    func isNameValid(_ name: String) -> Bool{
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmedName.isEmpty
    }
    
    func isNameDuplicate(_ name: String) -> Bool{
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let lowerCasedName = trimmedName.lowercased()
        return bill.guests.contains{guest in
            guest.name.lowercased() == lowerCasedName
        }
    }
    
    private func getRandomAvatar() -> String{
        let randomNumber = Int.random(in: 1...6)
        return "avatar\(randomNumber)"
    }
}
