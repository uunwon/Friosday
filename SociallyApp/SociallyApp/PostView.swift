//
//  PostView.swift
//  SociallyApp
//
//  Created by uunwon on 7/26/24.
//

import SwiftUI

struct PostView: View {
    @EnvironmentObject private var viewModel: PostViewModel
    @State private var description = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Description", text: $description)
                }
                
                Section {
                    Button(action: {
                        Task {
                            await self.viewModel.addData(description: description,
                                                         datePublished: Date())
                        }
                    }) {
                        Text("Post")
                    }
                }
            }
            .navigationTitle("New Post")
        }
    }
}

#Preview {
    PostView()
        .environmentObject(PostViewModel())
}
