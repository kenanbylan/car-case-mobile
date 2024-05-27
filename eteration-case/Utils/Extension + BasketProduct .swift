//
//  BasketProduct + Extension.swift
//  eteration-case
//
//  Created by Kenan Baylan on 26.05.2024.
//

import Foundation

extension BasketProduct {
    func toProduct() -> Product {
        return Product(
            createdAt: nil,
            id: self.productId ?? "",
            name: self.name ?? "",
            image: self.image ?? "",
            price: self.price,
            description: "",
            model: "",
            brand: ""
        )
    }
}
