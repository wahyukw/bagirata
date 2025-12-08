//
//  LoginView.swift
//  Bagirata
//
//  Created by Wahyu K on 6/12/2025.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack(spacing: 32){
            Spacer()
            
            Image(systemName: "dollarsign.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.blue)
            
            VStack(spacing: 12){
                Text("Bagirata")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Split bills easily with friends")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
            
            VStack(spacing: 16){
                SignInWithAppleButton()
                    .frame(height: 50)
                    .padding(.horizontal, 40)
                
                Text("Your data stays private and secure")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    LoginView()
        .environment(AuthenticationManager())
}
