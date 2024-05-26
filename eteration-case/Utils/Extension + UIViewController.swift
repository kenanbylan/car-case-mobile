//
//  Extension + UIViewController.swift
//  eteration-case
//
//  Created by Kenan Baylan on 25.05.2024.
//

import UIKit
extension UIViewController {
    
    func addCustomHeader(title: String = "E-Market", showBackButton: Bool = false, backAction: (() -> Void)? = nil) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        // Check if header is already added
        if view.subviews.contains(where: { $0 is HeaderView }) {
            return
        }
        
        let headerView = HeaderView()
        headerView.configure(title: title, showBackButton: showBackButton, backAction: backAction)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100) // Adjust the height as needed
        ])
    }
}
