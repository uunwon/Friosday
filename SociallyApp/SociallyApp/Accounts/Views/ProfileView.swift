//
//  ProfileView.swift
//  SociallyApp
//
//  Created by uunwon on 7/26/24.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @EnvironmentObject var authModel: AuthViewModel
    
    @State private var showSignUp: Bool = false
    
    @State var data: Data?
    @State var selectedItem: [PhotosPickerItem] = []
    
    var body: some View {
        VStack(alignment: .center) {
            if authModel.user != nil {
                Form {
                    Section("Your account") {
                        VStack {
                            PhotosPicker(selection: $selectedItem, maxSelectionCount: 1, selectionBehavior: .default, matching: .images, preferredItemEncoding: .automatic) {
                                AsyncImage(url: authModel.user?.photoURL) { phase in
                                    switch phase {
                                    case .empty:
                                        EmptyView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 80, height: 80)
                                            .clipped()
                                    case .failure:
                                        Image(systemName: "person.circle")
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                Label("Select a picture", systemImage: "photo.on.rectangle.angled")
                            }.onChange(of: selectedItem) { _, newValue in
                                guard let item = selectedItem.first else {
                                    return
                                }
                                item.loadTransferable(type: Data.self) { result in
                                    switch result {
                                    case .success(let data):
                                        if let data = data {
                                            self.data = data
                                            authModel.uploadProfileImage(data)
                                        }
                                    case .failure(let failure):
                                        print("Error: \(failure.localizedDescription)")
                                    }
                                }
                            }
                            Text(authModel.user?.email ?? "")
                        }
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
