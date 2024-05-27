//
//  MockNetworkManager.swift
//  eteration-caseTests
//
//  Created by Kenan Baylan on 26.05.2024.
//

import XCTest
@testable import eteration_case

class MockNetworkManager: NetworkManagerProtocol {
    var fetchProductsResult: Result<[Product], Error>?
    
    func fetchProducts(page: Int, pageSize: Int, completion: @escaping (Result<[Product], Error>) -> Void) {
        if let result = fetchProductsResult {
            completion(result)
        }
    }
}

let mockData = Product(
    createdAt: "2023-07-17T02:49:46.692Z",
    id: "2",
    name: "Aston Martin Durango",
    image: "https://loremflickr.com/640/480/food",
    price: 374.00,
    description: "Odio et voluptates velit omnis incidunt dolor. Illo sint quisquam tenetur dolore nemo molestiae. Dolorum odio dicta placeat. Commodi rerum molestias quibusdam labore. Odio libero doloribus. Architecto repellendus aperiam nulla at at voluptatibus ipsum.\nFugit expedita a quo totam quaerat amet eveniet laboriosam. Ad assumenda atque porro neque iusto. Inventore repudiandae esse non sit veritatis ab reprehenderit quas. Sit qui natus exercitationem quis commodi vero.\nIure reiciendis quas corrupti incidunt repellat voluptatem esse eveniet. Aliquid illo cum doloremque similique. Blanditiis corporis repellendus cumque totam quod iusto dolorum. Incidunt a eos eum voluptas tempora voluptas reiciendis autem.",
    model: "Roadster",
    brand: "Smart"
)

let mockProducts: [Product] = [mockData]
