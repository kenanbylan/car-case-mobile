//
//  HomeViewModel.swift
//  eteration-case
//
//  Created by Kenan Baylan on 25.05.2024.
//

import Foundation

final class HomeViewModel {
    
    var reloadCollectionView: (() -> Void)?
    var filteredProducts: [Product] = []
    var allProducts: [Product] = []
    
    func fetchProducts() {
        NetworkManager.shared.fetchProducts { [weak self] result in
            switch result {
            case .success(let products):
                self?.allProducts = products
                self?.filteredProducts = products
                DispatchQueue.main.async {
                    self?.reloadCollectionView?()
                }
            case .failure(let error):
                print("Failed to fetch products: \(error)")
            }
        }
    }
    
    func filterProducts(searchText: String) {
        if searchText.isEmpty {
            filteredProducts = allProducts
        } else {
            filteredProducts = allProducts.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        reloadCollectionView?()
    }
    
    func applyFilters(brands: [String], models: [String], sortOption: SortOption) {
        filteredProducts = allProducts.filter { product in
            let matchesBrand = brands.isEmpty || brands.contains(product.brand)
            let matchesModel = models.isEmpty || models.contains(product.model)
            return matchesBrand && matchesModel
        }
        
        switch sortOption {
        case .oldToNew:
            filteredProducts.sort { $0.createdAt ?? "" < $1.createdAt ?? "" }
        case .newToOld:
            filteredProducts.sort { $0.createdAt ?? "" > $1.createdAt ?? "" }
        case .priceHighToLow:
            filteredProducts.sort { $0.price > $1.price }
        case .priceLowToHigh:
            filteredProducts.sort { $0.price < $1.price }
        }
        
        reloadCollectionView?()
    }
}
