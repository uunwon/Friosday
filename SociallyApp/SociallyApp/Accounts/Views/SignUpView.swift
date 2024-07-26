//
//  SignUpView.swift
//  SociallyApp
//
//  Created by uunwon on 7/26/24.
//

import SwiftUI
import AuthenticationServices
import FirebaseAuth
import FirebaseFirestore

struct SignUpView: View {
    @EnvironmentObject private var authModel: AuthViewModel
    
    var body: some View {
        VStack {
            SignInWithAppleButton(onRequest: authModel.signInWithApple(request:),
                                  onCompletion: authModel.signInWithAppleCompletion(result:))
            .signInWithAppleButtonStyle(.black)
            .frame(width: 290, height: 45, alignment: .center)
        }
    }
}

#Preview {
    SignUpView()
}
