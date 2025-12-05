//
//  SignInWithAppleButton.swift
//  Bagirata
//
//  Created by Wahyu K on 6/12/2025.
//

import SwiftUI
import AuthenticationServices

struct SignInWithAppleButton: View {
    
    @Environment(AuthenticationManager.self) private var authManager
    
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        SignInWithAppleButtonViewRepresentable(
            onSuccess: { userID, email, fullName in
                authManager.handleSignInSuccess(
                    userID: userID,
                    email: email,
                    fullName: fullName
                )
            },
            onError: {error in
                errorMessage = error.localizedDescription
                showError = true
            }
        )
        .frame(height: 50)
        .alert("Sign In Error", isPresented: $showError){
            Button("OK", role: .cancel){}
        } message: {
            Text(errorMessage)
        }
    }
}

struct SignInWithAppleButtonViewRepresentable: UIViewRepresentable {
    let onSuccess: (String, String?, PersonNameComponents?) -> Void
    let onError: (Error) -> Void
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        let button = ASAuthorizationAppleIDButton(
            authorizationButtonType: .signIn,
            authorizationButtonStyle: .black
        )
        button.addTarget(
            context.coordinator,
            action: #selector(Coordinator.handleSignInWithApple),
            for: .touchUpInside
        )
        
        return button
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onSuccess: onSuccess, onError: onError)
    }
    
    class Coordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{
        
        let onSuccess: (String, String?, PersonNameComponents?) -> Void
        let onError: (Error) -> Void
        
        init(onSuccess: @escaping(String, String?, PersonNameComponents?) -> Void, onError: @escaping(Error) -> Void){
            self.onSuccess = onSuccess
            self.onError = onError
        }
        
        @objc func handleSignInWithApple(){
            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
        
        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            if let credential = authorization.credential as? ASAuthorizationAppleIDCredential{
                let userID = credential.user
                let email = credential.email
                let fullName = credential.fullName
                
                onSuccess(userID, email, fullName)
            }
        }
        
        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
            onError(error)
        }
        
        func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = scene.windows.first else{
                return UIWindow()
            }
            return window
        }
        
    }
}

#Preview {
    SignInWithAppleButton()
}
