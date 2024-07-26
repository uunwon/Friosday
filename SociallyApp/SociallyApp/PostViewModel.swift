//
//  PostViewModel.swift
//  SociallyApp
//
//  Created by uunwon on 7/26/24.
//

import Combine
import FirebaseFirestore

// ✨ 게시물 데이터를 관리하는 ViewModel
// = Firebase Firestore 데베와 통신해 게시물 데이터를 저장하고 업데이트함
class PostViewModel: ObservableObject {
    @Published var posts = [Post]()
    
    private var databaseReference = Firestore.firestore().collection("Posts")
    
    // 주어진 데이터를 Firestore "Posts" 컬렉션에 새 문서로 추가함
    func addData(description: String, datePublished: Date) async {
        do {
            _ = try await databaseReference.addDocument(data: [
                "description": description,
                "datePublished": datePublished
            ])
        } catch {
            print(error.localizedDescription)
        }
    }
}
