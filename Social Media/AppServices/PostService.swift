//
//  PostService.swift
//  Social Media
//
//  Created by Philipp Lazarev on 20.09.2024.
//

import Foundation


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
    
    func getUserID(for postID: String) -> String {
        return String(postID.dropLast(15))
    }
    
    func getDate(for postID: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        
        return dateFormatter.date(from: String(postID.suffix(14)))!
    }
    
    func publishPost(post: Post) {
        
    }
    
    func deletePost(post: Post) {
        
    }
    
    func getAllPosts() -> [Post] {
        return []
    }
    
    func getMyPosts() -> [Post] {
        return []
    }
}
