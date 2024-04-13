//
//  NetworkClient.swift
//  searchMedia
//
//  Created by snydia on 12.04.2024.
//

import Foundation

enum NetworkClientError: Error {
    case emptyResult
}

final class NetworkClient {
    private let basicPathURL = URL(string: "https://itunes.apple.com")!
    
    func fetch<T: Decodable>(_ api: NetworkAPI, completion: @escaping (Result<T, Error>) -> Void) {
        let url = basicPathURL.appendingPathComponent(api.path)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.url?.append(queryItems: ConvertDictionaryToQuery().convert(from: api.method))
        urlRequest.httpMethod = NetworkMethodToStringConverter().convert(from: api.method)
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            if let data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                    let model = try decoder.decode(T.self, from: data)
                    completion(.success(model))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NetworkClientError.emptyResult))
            }
            
        }.resume()
    }
}

private struct NetworkMethodToStringConverter {
    func convert(from value: NetworkMethod) -> String {
        switch value {
        case .getWithQueryParams:
            return "GET"
        }
    }
}

private struct ConvertDictionaryToQuery {
    func convert(from value: NetworkMethod) -> [URLQueryItem] {
        switch value {
        case .getWithQueryParams(let dictionary):
            return dictionary.map {
                URLQueryItem(name: $0, value: $1)
            }
        }
    }
}
