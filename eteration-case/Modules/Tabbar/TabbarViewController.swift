//
//  TabbarViewController.swift
//  eteration-case
//
//  Created by Kenan Baylan on 25.05.2024.
//

import UIKit

final class TabbarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabbarInitView()
        loadHomeTab()
        loadBasketTab()
        loadFavoriteTab()
        loadProfileTab()
        updateBasketBadge()
        NotificationCenter.default.addObserver(self, selector: #selector(updateBasketBadge), name: .cartUpdated, object: nil)
    }
    
    private func tabbarInitView() {
        tabBar.tintColor = .systemBlue
        tabBar.backgroundColor = .systemBackground
        tabBar.unselectedItemTintColor = .lightGray
        tabBar.isTranslucent = true
    }
    
    func loadHomeTab() {
        let navigationController = CustomNavigationController()
        let homeView = HomeViewController()
        navigationController.viewControllers.append(homeView)
        navigationController.tabBarItem.image = UIImage(named: Tabbar.home)
        self.addChild(navigationController)
    }
    
    func loadBasketTab() {
        let navigationController = CustomNavigationController()
        let basket = BasketViewController()
        navigationController.viewControllers.append(basket)
        navigationController.tabBarItem.image = UIImage(named: Tabbar.basket)
        self.addChild(navigationController)
    }
    
    func loadFavoriteTab() {
        let navigationController = CustomNavigationController()
        let fav = FavoriteViewController()
        navigationController.viewControllers.append(fav)
        navigationController.tabBarItem.image = UIImage(named: Tabbar.favorite)
        self.addChild(navigationController)
    }
    
    func loadProfileTab() {
        let navigationController = CustomNavigationController()
        let profile = ProfileViewController()
        navigationController.viewControllers.append(profile)
        navigationController.tabBarItem.image = UIImage(named: Tabbar.profile)
        self.addChild(navigationController)
    }
    
    @objc private func updateBasketBadge() {
        if let tabItems = tabBar.items {
            let basketTabItem = tabItems[1]
            let itemCount = CoreDataManager.shared.basketItemCount()
            basketTabItem.badgeValue = itemCount > 0 ? "\(itemCount)" : nil
        }
    }
}
