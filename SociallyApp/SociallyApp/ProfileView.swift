//
//  ProfileView.swift
//  SociallyApp
//
//  Created by uunwon on 7/26/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authModel: AuthViewModel
    
    @State private var showSignUp: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            if authModel.user != nil {
                Form {
                    Section("Your account") {
                        Text(authModel.user?.email ?? "")
                    }
                    Button {
                        authModel.signOut()
                    } label: {
                        Text("Logout")
                            .foregroundStyle(Color.red)
                    }
                }
            } else {
                Form {
                    Section("Your account") {
                        Text("Seems like you are not logged in, create an account")
                    }
                    Button {
                        showSignUp.toggle()
                    } label: {
                        Text("Sign Up")
                            .foregroundStyle(Color.blue)
                            .bold()
                    }
                    .sheet(isPresented: $showSignUp) {
                        SignUpView().presentationDetents([.height(100), .medium, .large])
                    }
                }
            }
        }
        .onAppear { authModel.listenToAuthState() }
    }
}

#Preview {
    ProfileView()
}
