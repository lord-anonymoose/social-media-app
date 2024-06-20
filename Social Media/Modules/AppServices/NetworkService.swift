//
//  NetworkService.swift
//  Social Media
//
//  Created by Philipp Lazarev on 20.06.2024.
//

import Foundation
import UIKit

struct NetworkService {
    static func request(for configuration: AppConfiguration, completion: @escaping (Result<Any, Error>) -> Void) {
        switch getBaseURL(for: configuration) {
        case .success(let url):
            let session = URLSession.shared
            let task = session.dataTask(with: url) { (data, response, error) in
                if let data {
                    print("data: \(data)")
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        completion(.success(json))
                    } catch {
                        print(NetworkError.jsonError.description)
                        completion(.failure(NetworkError.jsonError))
                    }
                } else {
                    print(NetworkError.jsonError.description)
                    completion(.failure(NetworkError.jsonError))
                }
            
                if let httpResponse = response as? HTTPURLResponse {
                    print(".HeaderFields: \(httpResponse.allHeaderFields)")
                    print(".statusCode: \(httpResponse.statusCode)")
                } else {
                    print(NetworkError.httpResponseError.description)
                    completion(.failure(NetworkError.httpResponseError))
                }
                
                if let error = error as? URLError {
                    print("URLError code: \(error.code.rawValue)")
                } else {
                    if let error {
                        print("Error: \(error)")
                        completion(.failure(error))
                    }
                }
            }
            
            task.resume()
            
        case .failure(let error):
            completion(.failure(error))
            return
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
        return .failure(NetworkError.urlError)
    }
}
