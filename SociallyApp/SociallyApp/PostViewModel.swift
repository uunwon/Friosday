//
//  PostViewModel.swift
//  SociallyApp
//
//  Created by uunwon on 7/26/24.
//

import Combine
import FirebaseFirestore

class PostViewModel: ObservableObject {
    @Published var posts = [Post]()
    
    private var databaseReference = Firestore.firestore().collection("Posts")
}
