//
//  NetworkService.swift
//  Social Media
//
//  Created by Philipp Lazarev on 20.06.2024.
//

import Foundation
import UIKit

struct NetworkService {
    static func request(for configuration: AppConfiguration) throws {
        switch getBaseURL(for: configuration) {
        case .success(let url):
            print("Succedeed with \(url)")
            
            let session = URLSession.shared
            let task = session.dataTask(with: url) { (data, response, error) in
                if let data {
                    print("Data is: \(data)")
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                    } catch {
                        print("Ошибка обработки JSON")
                    }
                } else {
                    print(AppError.jsonError.description)
                    throw AppError.jsonError
                }
            
                guard let httpResponse = response as? HTTPURLResponse else {
                    return
                }
                
                if let error {
                    print("Error is: \(error)")
                } else {
                    return
                }
                

            }
            
            task.resume()
            
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
