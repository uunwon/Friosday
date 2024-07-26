//
//  PostViewModel.swift
//  SociallyApp
//
//  Created by uunwon on 7/26/24.
//

import Combine
import FirebaseFirestore
import FirebaseStorage

// ✨ 게시물 데이터를 관리하는 ViewModel
// = Firebase Firestore 데베와 통신해 게시물 데이터를 저장하고 업데이트함
class PostViewModel: ObservableObject {
    
    private var databaseReference = Firestore.firestore().collection("Posts")
    
    // 주어진 데이터를 Firestore "Posts" 컬렉션에 새 문서로 추가함
    func addData(description: String, datePublished: Date, data: Data, completion: @escaping (Error?) -> Void) {
        let storageReference = Storage.storage().reference().child("\(UUID().uuidString)")
        
        storageReference.putData(data, metadata: nil) { metadata, error in
            if let error = error {
                completion(error)
                return
            }
            
            storageReference.downloadURL { url, error in
                if let error = error {
                    completion(error)
                    return
                }
                
                guard let downloadURL = url else {
                    completion(NSError(domain: "URLError", code: 0, userInfo: nil))
                    return
                }
                
                self.databaseReference.addDocument(data: [
                    "description": description,
                    "datePublished": datePublished,
                    "imageURL": downloadURL.absoluteString
                ]) { error in
                    completion(error)
                }
            }
        }
    }
}
