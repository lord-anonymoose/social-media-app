//
//  Post.swift
//  Social Media
//
//  Created by Philipp Lazarev on 12.09.2024.
//

import Foundation



struct Post {
    var postID: String
    var author: String
    var description: String
    var date: Date
    var likes: Int = 0
    
    init(postID: String, description: String, likes: Int = 0) {
        self.postID = postID
        self.author = PostService.shared.getAuthorID(for: postID)
        self.description = description
        self.date = PostService.shared.getDate(for: postID)
        self.likes = likes
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "description": description,
            "likes": likes
        ]
    }
}
