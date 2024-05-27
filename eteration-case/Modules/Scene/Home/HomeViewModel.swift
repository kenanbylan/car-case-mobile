//
//  HomeViewModel.swift
//  eteration-case
//
//  Created by Kenan Baylan on 25.05.2024.
//

import Foundation

protocol HomeViewModelProtocol {
    var reloadCollectionView: (() -> Void)? { get set }
    var numberOfItems: Int { get }
    func product(at indexPath: IndexPath) -> Product?
    func fetchProducts()
    func filterProducts(searchText: String)
    func applyFilters(brands: [String], models: [String], sortOption: SortOption)
    
    var isLoading: Bool { get set }
}

final class HomeViewModel: HomeViewModelProtocol {
    var reloadCollectionView: (() -> Void)?
    private let networkManager: NetworkManagerProtocol
    
    var filteredProducts: [Product] = []
    private var allProducts: [Product] = []
    
    private var currentPage = 1
    private let pageSize = 20
    var isLoading = false
    private var hasMoreData = true
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    var numberOfItems: Int {
        return filteredProducts.count
    }
    
    func product(at indexPath: IndexPath) -> Product? {
        guard indexPath.row < filteredProducts.count else { return nil }
        return filteredProducts[indexPath.row]
    }
    
    func fetchProducts() {
        guard !isLoading && hasMoreData else { return }
        isLoading = true
        networkManager.fetchProducts(page: currentPage, pageSize: pageSize) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let products):
                if products.count < self.pageSize {
                    self.hasMoreData = false
                }
                self.allProducts.append(contentsOf: products)
                self.filteredProducts = self.allProducts
                DispatchQueue.main.async {
                    self.reloadCollectionView?()
                }
                self.currentPage += 1
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
