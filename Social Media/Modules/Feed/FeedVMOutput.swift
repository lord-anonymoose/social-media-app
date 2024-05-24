//
//  FeedProtocol.swift
//  Social Media
//
//  Created by Philipp Lazarev on 21.05.2024.
//

import UIKit

final class FeedVMOutput {
    
    private let service: FeedService
    
    var currentState: ((State) -> Void)?
    
    var state: State = .initial {
        didSet {
            currentState?(state)
        }
    }
    
    init(service: FeedService) {
        self.service = service
    }
    
    func changeState() {
        state = .loading
        service.loadPosts { [weak self] result in
            guard let self else { return }
            switch result {
                case .success(let posts):
                    state = .loaded(posts)
                case .failure(_):
                    state = .error
            }
        }
    }
}

enum State {
    case initial
    case loading
    case loaded([StorageService.Post])
    case error
}
