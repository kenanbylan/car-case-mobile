//
//  Extension + NotificationCenter.swift
//  eteration-case
//
//  Created by Kenan Baylan on 25.05.2024.
//

import Foundation

extension Notification.Name {
    static let didUpdateFavorites = Notification.Name("didUpdateFavorites")
    static let favoritesUpdated = NSNotification.Name("favoritesUpdated")
    static let cartUpdated = Notification.Name("cartUpdated")
}
