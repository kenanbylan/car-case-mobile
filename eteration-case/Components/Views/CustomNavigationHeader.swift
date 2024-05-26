//
//  CustomNavigationHeader.swift
//  eteration-case
//
//  Created by Kenan Baylan on 25.05.2024.
//
import UIKit

final class CustomNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        viewController.addCustomHeader(title: viewController.title ?? "", showBackButton: true) { [weak self] in
            self?.popViewController(animated: true)
        }
    }
}

