//
//  SociallyAppApp.swift
//  SociallyApp
//
//  Created by uunwon on 7/26/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct SociallyAppApp: App {
    @StateObject var authModel = AuthViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            TabView {
                if authModel.user != nil {
                    FeedView()
                        .tabItem {
                            Image(systemName: "text.bubble")
                            Text("Feeds")
                        }
                }
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("Account")
                    }
            }
            .environmentObject(authModel)
            .environmentObject(PostViewModel())
        }
    }
}
