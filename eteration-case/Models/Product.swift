//
//  Product.swift
//  eteration-case
//
//  Created by Kenan Baylan on 25.05.2024.
//

import Foundation

struct Product: Codable {
    let createdAt: String?
    let id: String
    let name: String
    let image: String
    let price: Double
    let description: String
    let model: String
    let brand: String
    
    enum CodingKeys: String, CodingKey {
        case createdAt, id, name, image, price, description, model, brand
    }
    
    var imageURL: URL? {
        return URL(string: image)
    }
    
    init(createdAt: String?, id: String, name: String, image: String, price: Double, description: String, model: String, brand: String) {
        self.createdAt = createdAt
        self.id = id
        self.name = name
        self.image = image
        self.price = price
        self.description = description
        self.model = model
        self.brand = brand
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.image = try container.decode(String.self, forKey: .image)
        self.description = try container.decode(String.self, forKey: .description)
        self.model = try container.decode(String.self, forKey: .model)
        self.brand = try container.decode(String.self, forKey: .brand)
        
        let priceString = try container.decode(String.self, forKey: .price)
        if let price = Double(priceString) {
            self.price = price
        } else {
            throw DecodingError.dataCorruptedError(forKey: .price, in: container, debugDescription: "Price string cannot be converted to Double")
        }
    }
}
