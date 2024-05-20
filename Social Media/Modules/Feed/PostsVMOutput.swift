//
//  FeedProtocol.swift
//  Social Media
//
//  Created by Philipp Lazarev on 21.05.2024.
//

import Foundation

protocol PostsVMOutput {
    var state: State { get set }
    var currentState: ((State) -> Void)? { get set }
    func changeState()
}

enum State {
    case initial
    case loading
    case loaded([StorageService.Post])
    case error
}
