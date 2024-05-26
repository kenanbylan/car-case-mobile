//
//  FavoriteViewModel.swift
//  eteration-case
//
//  Created by Kenan Baylan on 25.05.2024.
//

import Foundation

final class FavoriteViewModel {
    private let coreDataManager = CoreDataManager.shared
    
    var favoritesUpdated: (() -> Void)?
    
    func addToFavorites(product: Product) {
        coreDataManager.addFavoriteProduct(product: product)
        favoritesUpdated?()
    }
    
    func removeFromFavorites(product: Product) {
        coreDataManager.removeFavoriteProduct(product: product)
        favoritesUpdated?()
    }
    
    func isFavorite(product: Product) -> Bool {
        return coreDataManager.isFavorite(product: product)
    }
    
    func fetchFavoriteProducts() -> [FavoriteProduct] {
        return coreDataManager.fetchFavoriteProducts()
    }
    
    func fetchFavorites(completion: @escaping () -> Void) {
        favoritesUpdated?()
        completion()
    }
    
    func removeFavorite(at indexPath: IndexPath) {
        let favoriteProducts = fetchFavoriteProducts()
        let product = favoriteProducts[indexPath.row]
        coreDataManager.context.delete(product)
        coreDataManager.saveContext()
        favoritesUpdated?()
    }
}
