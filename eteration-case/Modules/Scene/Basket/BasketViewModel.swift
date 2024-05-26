//
//  BasketViewModel.swift
//  eteration-case
//
//  Created by Kenan Baylan on 25.05.2024.
//

import CoreData

final class BasketViewModel {
    static let shared = BasketViewModel() // Singleton instance
    private init() {
        fetchCartItems()
    }
    
    private(set) var cartItems: [BasketProduct] = []
    
    var reloadTableView: (() -> Void)?
    
    var totalPrice: Double {
        return cartItems.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }
    
    var onCartItemsUpdated: (() -> Void)?
    
    private let coreDataManager = CoreDataManager.shared
    
    func addToCart(product: Product) {
        coreDataManager.addBasketProduct(product: product)
        fetchCartItems()
        onCartItemsUpdated?()
    }
    
    func incrementQuantity(of product: Product) {
        coreDataManager.incrementBasketProductQuantity(product: product)
        fetchCartItems()
        onCartItemsUpdated?()
    }
    
    func decrementQuantity(of product: Product) {
        coreDataManager.decrementBasketProductQuantity(product: product)
        fetchCartItems()
        onCartItemsUpdated?()
    }
    
    private func fetchCartItems() {
        cartItems = coreDataManager.fetchBasketProducts()
    }
}
