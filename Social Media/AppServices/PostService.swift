//
//  PostService.swift
//  Social Media
//
//  Created by Philipp Lazarev on 20.09.2024.
//

import Foundation
import Firebase
import FirebaseStorage



final class PostService {

    static let shared = PostService()
    
    private init() {
        
    }
    
    func generatePostID(for userID: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        
        let date = Date()
        let formattedDate = dateFormatter.string(from: date)
        
        let result = "\(userID)_\(formattedDate)"
        
        return result
    }
    
    func getAuthorID(for postID: String) -> String {
        return String(postID.dropLast(15))
    }
    
    func getDate(for postID: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        
        return dateFormatter.date(from: String(postID.suffix(14)))!
    }
    
    func fetchPost(withID postID: String, completion: @escaping (Post?) -> Void) {
        let ref = Database.database().reference().child("posts").child(postID)
        
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let postDict = snapshot.value as? [String: Any],
                  let description = postDict["description"] as? String,
                  let likes = postDict["likes"] as? Int else {
                completion(nil)
                return
            }
            let post = Post(postID: postID, description: description, likes: likes)
            completion(post)
        }
    }
    
    func fetchLikedPosts(completion: @escaping ([Post]) -> Void) {
        var result = [Post]()
        
        guard let userID = try? FirebaseService.shared.currentUserID() else {
            completion([])
            return
        }
        
        FirebaseService.shared.fetchUser(by: userID) { user in
            if let user {
                let likesIDs = user.likes
                let dispatchGroup = DispatchGroup()
                
                for likeID in likesIDs {
                    dispatchGroup.enter()
                    PostService.shared.fetchPost(withID: likeID) { post in
                        if let post {
                            result.append(post)
                        }
                        dispatchGroup.leave()
                    }
                }
                dispatchGroup.notify(queue: .main) {
                    completion(result)
                }
            } else {
                completion([])
            }
        }
    }
    
    func fetchAllPosts(completion: @escaping ([Post]) -> Void) {
        let ref = Database.database().reference().child("posts")
        
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let postsDict = snapshot.value as? [String: [String: Any]] else {
                completion([])
                return
            }
            
            var posts: [Post] = []
            for (postID, postData) in postsDict {
                if let description = postData["description"] as? String,
                   let likes = postData["likes"] as? Int {
                    let post = Post(postID: postID, description: description, likes: likes)
                    posts.append(post)
                }
            }
            completion(posts)
        }
    }
    
    func fetchPosts(for userID: String, completion: @escaping ([Post]) -> Void) {
        var result = [Post]()
        fetchAllPosts { posts in
            for post in posts {
                if post.author == userID {
                    result.append(post)
                }
            }
            completion(result)
        }
    }
    
    func likePost(postID: String?, completion: @escaping (Error?) -> Void) {
        
        guard let postID else {
            completion(FirebaseServiceError.invalidEmail)
            return
        }
        
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(FirebaseServiceError.userNotExist)
            return
        }
        
        let ref = Database.database().reference().child("users").child(userID).child("likes")
        
        ref.observeSingleEvent(of: .value) { snapshot in
            var likes = snapshot.value as? [String] ?? []
            
            if likes.contains(postID) {
                likes.removeAll { $0 == postID }
            } else {
                likes.append(postID)
            }

            ref.setValue(likes) { error, _ in
                completion(error)
            }
        }
    }
    
    func isPostLikedByCurrentUser(postID: String, completion: @escaping (Bool) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }
        
        let ref = Database.database().reference().child("users").child(userID).child("likes")
        
        ref.observeSingleEvent(of: .value) { snapshot in
            if let likes = snapshot.value as? [String], likes.contains(postID) {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func publishPost(image: UIImage, description: String, completion: @escaping (Error?) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(FirebaseServiceError.userNotExist)
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Couldn't convert image into jpeg")
            return
        }
        

        let postID = self.generatePostID(for: userID)
        
        let newPost = Post(postID: postID, description: description)
        
        let postDict = newPost.toDictionary()
        
        let ref = Database.database().reference().child("posts").child(postID)
        

        ref.setValue(postDict) { error, _ in
            if let error = error {
                completion(error)
            } else {

                let storageRef = Storage.storage().reference().child("Posts/\(postID).jpg")

                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                
                storageRef.putData(imageData, metadata: metadata) { metadata, error in
                    if let error = error {
                        completion(error)
                        return
                    }

                    storageRef.downloadURL { url, error in
                        if let error = error {
                            completion(error)
                            return
                        }

                        if url != nil {
                            completion(nil)
                        }
                    }
                }
                
            }
        }
    }
}
