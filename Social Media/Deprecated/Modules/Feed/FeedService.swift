//
//  FeedService.swift
//  Social Media
//
//  Created by Philipp Lazarev on 21.05.2024.
//

/*
 
 FOLLOWING CODE IS DEPRECATED AND IS NOT USED IN LATEST APP VERSIONS
 
 */

/*
import Foundation

class FeedService {
    private var loadedPosts: [StorageService.Post] = []
    
    func loadPosts(completion: @escaping (Result<[StorageService.Post], Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.loadedPosts = posts.shuffled()
            completion(.success(posts))
        }
    }
    
    func numberOfItems() -> Int {
        return self.loadedPosts.count
    }
    
    func item(index: Int) -> StorageService.Post? {
        if index >= 0 && index < self.loadedPosts.count {
            return self.loadedPosts[index]
        } else {
            return nil
        }
    }
}
*/
