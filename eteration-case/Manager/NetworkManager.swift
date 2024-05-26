//
//  NetworkManager.swift
//  eteration-case
//
//  Created by Kenan Baylan on 25.05.2024.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        guard let url = URL(string: "https://5fc9346b2af77700165ae514.mockapi.io/products") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "DataError", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let products = try JSONDecoder().decode([Product].self, from: data)
                completion(.success(products))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
