//
//  BasketViewModel.swift
//  eteration-case
//
//  Created by Kenan Baylan on 25.05.2024.
//

import CoreData

protocol BasketViewModelProtocol {
    var delegate: BasketViewModelDelegate? { get set }
    var cartItems: [BasketProduct] { get }
    var totalPrice: Double { get }
    func addToCart(product: Product)
    func incrementQuantity(of product: Product)
    func decrementQuantity(of product: Product)
}

protocol BasketViewModelDelegate: AnyObject {
    func onCartItemsUpdated()
}

final class BasketViewModel: BasketViewModelProtocol {
    static let shared = BasketViewModel()
    
    weak var delegate: BasketViewModelDelegate?
    
    private init() {
        fetchCartItems()
    }
    
    private(set) var cartItems: [BasketProduct] = []
    
    var totalPrice: Double {
        return cartItems.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }
    
    private let coreDataManager: CoreDataManagerProtocol = CoreDataManager.shared
    
    func addToCart(product: Product) {
        coreDataManager.addBasketProduct(product: product)
        fetchCartItems()
        delegate?.onCartItemsUpdated()
    }
    
    func incrementQuantity(of product: Product) {
        coreDataManager.incrementBasketProductQuantity(product: product)
        fetchCartItems()
        delegate?.onCartItemsUpdated()
    }
    
    func decrementQuantity(of product: Product) {
        coreDataManager.decrementBasketProductQuantity(product: product)
        fetchCartItems()
        delegate?.onCartItemsUpdated()
    }
    
    private func fetchCartItems() {
        cartItems = coreDataManager.fetchBasketProducts()
    }
}
