//
//  Post.swift
//  Social Media
//
//  Created by Philipp Lazarev on 12.09.2024.
//

import Foundation

public struct Post {
    public var postID: String
    public var author: String
    public var description: String
    public var date: Date
    public var likes: Int = 0
    
    public init(postID: String, description: String, likes: Int = 0) {
        self.postID = postID
        self.author = PostService.shared.getUserID(for: postID)
        self.description = description
        self.date = PostService.shared.getDate(for: postID)
        self.likes = likes
    }
    
    public func toDictionary() -> [String: Any] {
        return [
            "author": author,
            "description": description,
            "likes": likes
        ]
    }
}
