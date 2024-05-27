//
//  CoreDataManager.swift
//  eteration-case
//
//  Created by Kenan Baylan on 25.05.2024.
//

import Foundation
import CoreData
import UIKit

protocol CoreDataManagerProtocol {
    func addBasketProduct(product: Product)
    func incrementBasketProductQuantity(product: Product)
    func decrementBasketProductQuantity(product: Product)
    func fetchBasketProducts() -> [BasketProduct]
    func addFavoriteProduct(product: Product)
    func removeFavoriteProduct(product: Product)
    func isFavorite(product: Product) -> Bool
    func fetchFavoriteProducts() -> [FavoriteProduct]
}

final class CoreDataManager: CoreDataManagerProtocol {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "eteration_case")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: Favorites CoreData Manager
    func addFavoriteProduct(product: Product) {
        let favoriteProduct = FavoriteProduct(context: context)
        favoriteProduct.id = product.id
        favoriteProduct.name = product.name
        favoriteProduct.image = product.image
        favoriteProduct.price = product.price
        favoriteProduct.descriptions = product.description
        favoriteProduct.model = product.model
        favoriteProduct.brand = product.brand
        saveContext()
        NotificationCenter.default.post(name: .favoritesUpdated, object: nil)
    }
    
    func removeFavoriteProduct(product: Product) {
        let fetchRequest: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", product.id)
        if let result = try? context.fetch(fetchRequest), let favoriteProduct = result.first {
            context.delete(favoriteProduct)
            saveContext()
            NotificationCenter.default.post(name: .favoritesUpdated, object: nil)
        }
    }
    
    func isFavorite(product: Product) -> Bool {
        let fetchRequest: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", product.id)
        if let result = try? context.fetch(fetchRequest), result.first != nil {
            return true
        }
        return false
    }
    
    func fetchFavoriteProducts() -> [FavoriteProduct] {
        let fetchRequest: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
        if let result = try? context.fetch(fetchRequest) {
            return result
        }
        return []
    }
    
    // MARK: Basket CoreData Manager
    func addBasketProduct(product: Product) {
        let fetchRequest: NSFetchRequest<BasketProduct> = BasketProduct.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "productId == %@", product.id)
        if let result = try? context.fetch(fetchRequest), let basketProduct = result.first {
            basketProduct.quantity += 1
        } else {
            let basketProduct = BasketProduct(context: context)
            basketProduct.productId = product.id
            basketProduct.name = product.name
            basketProduct.price = product.price
            basketProduct.quantity = 1
            basketProduct.image = product.image
        }
        saveContext()
    }
    
    func incrementBasketProductQuantity(product: Product) {
        let fetchRequest: NSFetchRequest<BasketProduct> = BasketProduct.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "productId == %@", product.id)
        if let result = try? context.fetch(fetchRequest), let basketProduct = result.first {
            basketProduct.quantity += 1
            saveContext()
        }
    }
    
    func decrementBasketProductQuantity(product: Product) {
        let fetchRequest: NSFetchRequest<BasketProduct> = BasketProduct.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "productId == %@", product.id)
        if let result = try? context.fetch(fetchRequest), let basketProduct = result.first {
            if basketProduct.quantity > 1 {
                basketProduct.quantity -= 1
            } else {
                context.delete(basketProduct)
            }
            saveContext()
        }
    }
    
    func fetchBasketProducts() -> [BasketProduct] {
        let fetchRequest: NSFetchRequest<BasketProduct> = BasketProduct.fetchRequest()
        if let result = try? context.fetch(fetchRequest) {
            return result
        }
        return []
    }
    
    func basketItemCount() -> Int {
        return fetchBasketProducts().count
    }
}
