//
//  NetworkManager.swift
//  VBMovmania
//
//  Created by Suheda on 13.07.2024.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func download(with endpoint: Endpoint, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let request = endpoint.request else { return }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode >= 200, response.statusCode <= 299 else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badURL)))
                return
            }
            
            completion(.success(data))
        }
        task.resume()
    }
}
