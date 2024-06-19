//
//  NetworkService.swift
//  Social Media
//
//  Created by Philipp Lazarev on 20.06.2024.
//

import Foundation
import UIKit

struct NetworkService {
    static func request(for configuration: AppConfiguration) {
        switch getBaseURL(for: configuration) {
        case .success(let url):
            print("Succedeed with \(url)")
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}

enum AppConfiguration {
    case people
    case planets
    case films
    
    var baseURL: URL? {
        switch self {
        case .people:
            return(URL(string: "https://swapi.dev/api/people/"))
        case .planets:
            return(URL(string: "https://swapi.dev/api/planets/"))
        case .films:
            return(URL(string: "https://swapi.dev/api/films/"))
        }
    }
}

func getBaseURL(for configuration: AppConfiguration) -> Result<URL,Error> {
    if let url = configuration.baseURL {
        return .success(url)
    } else {
        return .failure(AppError.invalidURL)
    }
}
