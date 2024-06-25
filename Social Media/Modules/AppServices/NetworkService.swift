//
//  NetworkService.swift
//  Social Media
//
//  Created by Philipp Lazarev on 20.06.2024.
//

import Foundation
import UIKit

struct NetworkService {

    static func request(urlString: String, completion: @escaping (Result<Any, Error>) -> Void) {
        switch getBaseURL(urlString: urlString) {
        case .success(let url):
            let session = URLSession.shared
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if let error = error as? URLError {
                    print("URLError code: \(error.code.rawValue)")
                } else {
                    if let error {
                        print("Error: \(error)")
                        completion(.failure(error))
                        return
                    }
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print(".statusCode: \(httpResponse.statusCode)")
                } else {
                    print(NetworkError.httpResponseError.description)
                    completion(.failure(NetworkError.httpResponseError))
                    return
                }
                
                guard let data else {
                    print(NetworkError.jsonError.description)
                    completion(.failure(NetworkError.jsonError))
                    return
                }
                
                completion(.success(data))

            }
            
            task.resume()
            
        case .failure(let error):
            completion(.failure(error))
            return
        }
    }
    
    static func request(for configuration: AppConfiguration, completion: @escaping (Result<Any, Error>) -> Void) {
        switch getBaseURL(for: configuration) {
        case .success(let url):
            let session = URLSession.shared
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if let error = error as? URLError {
                    print("URLError code: \(error.code.rawValue)")
                } else {
                    if let error {
                        print("Error: \(error)")
                        completion(.failure(error))
                        return
                    }
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print(".statusCode: \(httpResponse.statusCode)")
                } else {
                    print(NetworkError.httpResponseError.description)
                    completion(.failure(NetworkError.httpResponseError))
                    return
                }
                
                guard let data else {
                    print(NetworkError.jsonError.description)
                    completion(.failure(NetworkError.jsonError))
                    return
                }
                
                completion(.success(data))

            }
            
            task.resume()
            
        case .failure(let error):
            completion(.failure(error))
            return
        }
    }
}

enum AppConfiguration: String, CaseIterable {
    case people = "https://swapi.dev/api/people"
    case planets = "https://swapi.dev/api/planets/"
    case films = "https://swapi.dev/api/films/"
    
    var url: URL? {
        URL(string: self.rawValue)
    }
}


func getBaseURL(for configuration: AppConfiguration) -> Result<URL,Error> {
    if let url = URL(string: configuration.rawValue) {
        return .success(url)
    } else {
        return .failure(NetworkError.urlError)
    }
}

func getBaseURL(urlString: String) -> Result<URL, Error> {
    if let url = URL(string: urlString) {
        return .success(url)
    } else {
        return .failure(NetworkError.urlError)
    }
}

/*
func getBaseURL(for urlstring: String) -> Result<URL, Error> {
    if let url = URL(string: urlstring) {
        return .success(url)
    } else {
        return .failure(NetworkError.urlError)
    }
}
*/
