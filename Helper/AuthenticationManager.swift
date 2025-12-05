//
//  AuthenticationManager.swift
//  Bagirata
//
//  Created by Wahyu K on 5/12/2025.
//

import Foundation
import SwiftUI
import AuthenticationServices

@Observable
class AuthenticationManager{
    var isAuthenticated: Bool = false
    var userID: String?
    var userEmail: String?
    var userFullName: String?
    var hasCompletedOnboarding: Bool = false
    
    private let userIDKey = "userID"
    private let sessionExpiryKey = "sessionExpiry"
    private let userEmailKey = "userEmail"
    private let userFullNameKey = "userFullName"
    private let onboardingKey = "hasCompletedOnboarding"
    
    init(){
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: onboardingKey)
        checkSession()
    }
    
    func checkSession() {
        guard let savedUserID = UserDefaults.standard.string(forKey: userIDKey),
              let expiryDate = UserDefaults.standard.object(forKey: sessionExpiryKey) as? Date else{
            isAuthenticated = false
            return
        }
        
        if Date() < expiryDate {
            isAuthenticated = true
            userID = savedUserID
            userEmail = UserDefaults.standard.string(forKey: userEmailKey)
            userFullName = UserDefaults.standard.string(forKey: userFullNameKey)
        } else{
            clearSession()
        }
    }
    
    func handleSignInSuccess(userID: String, email: String?, fullName: PersonNameComponents?){
        self.userID = userID
        self.isAuthenticated = true
        
        UserDefaults.standard.set(userID, forKey: userIDKey)
        
        if let fullName = fullName{
            let fullNameString = [fullName.givenName, fullName.familyName]
                .compactMap{$0}
                .joined(separator: " ")
            self.userFullName = fullNameString
            UserDefaults.standard.set(fullNameString, forKey: userFullNameKey)
        }
        
        let expiryDate = Calendar.current.date(byAdding: .day, value: 90, to: Date())!
        UserDefaults.standard.set(expiryDate, forKey: sessionExpiryKey)
    }
    
    func signOut(){
        clearSession()
    }
    
    private func clearSession(){
        isAuthenticated = false
        userID = nil
        userEmail = nil
        userFullName = nil
        
        UserDefaults.standard.removeObject(forKey: userIDKey)
        UserDefaults.standard.removeObject(forKey: sessionExpiryKey)
        UserDefaults.standard.removeObject(forKey: userEmailKey)
        UserDefaults.standard.removeObject(forKey: userFullNameKey)
    }
    
    func daysRemainingInSession () -> Int?{
        guard let expiryDate = UserDefaults.standard.object(forKey: sessionExpiryKey) as? Date else{
            return nil
        }
        
        let days = Calendar.current.dateComponents([.day], from: Date(), to: expiryDate).day
        return days
    }
    
    func completeOnboarding(){
        hasCompletedOnboarding = true
        UserDefaults.standard.set(true, forKey: onboardingKey)
    }
}
