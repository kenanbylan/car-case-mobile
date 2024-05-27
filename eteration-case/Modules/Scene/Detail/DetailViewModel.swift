//
//  DetailViewModel.swift
//  eteration-case
//
//  Created by Kenan Baylan on 25.05.2024.
//

import Foundation

protocol DetailViewModelProtocol {
    var product: Product { get }
    var productName: String { get }
    var productDescription: String { get }
    var productPrice: String { get }
    var productImageURL: URL? { get }
    var isFavorite: Bool { get }
    var favoriteStatusChanged: (() -> Void)? { get set }
    func addToCart()
}

final class DetailViewModel: DetailViewModelProtocol {
    private(set) var product: Product
    private let coreDataManager: CoreDataManagerProtocol
    
    var favoriteStatusChanged: (() -> Void)?
    
    init(product: Product, coreDataManager: CoreDataManagerProtocol = CoreDataManager.shared) {
        self.product = product
        self.coreDataManager = coreDataManager
    }
    
    var productName: String {
        return product.name
    }
    
    var productDescription: String {
        return product.description
    }
    
    var productPrice: String {
        return "Price: \(product.price) ₺"
    }
    
    var productImageURL: URL? {
        return URL(string: product.image)
    }
    
    var isFavorite: Bool {
        return coreDataManager.isFavorite(product: product)
    }
    
    func addToCart() {
        BasketViewModel.shared.addToCart(product: product)
    }
}
