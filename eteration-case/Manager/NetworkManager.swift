//
//  NetworkManager.swift
//  eteration-case
//
//  Created by Kenan Baylan on 25.05.2024.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchProducts(page: Int, pageSize: Int, completion: @escaping (Result<[Product], Error>) -> Void)
    
}

final class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    private init() {}
    
    private let baseURL = "https://5fc9346b2af77700165ae514.mockapi.io"
    
    func fetchProducts(page: Int, pageSize: Int, completion: @escaping (Result<[Product], Error>) -> Void) {
        let urlString = "\(baseURL)/products?page=\(page)&limit=\(pageSize)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
            return
        }
        
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
