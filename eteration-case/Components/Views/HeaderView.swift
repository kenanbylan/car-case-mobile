//
//  HeaderView.swift
//  eteration-case
//
//  Created by Kenan Baylan on 25.05.2024.
//

import UIKit

final class HeaderView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 21)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var backAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = UIColor.systemBlue
        
        self.addSubview(backButton)
        self.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant: 20),
        ])
    }
    
    func configure(title: String, showBackButton: Bool = false, backAction: (() -> Void)? = nil) {
        titleLabel.text = title
        backButton.isHidden = !showBackButton
        
        if showBackButton, let backAction = backAction {
            backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
            self.backAction = backAction
        } else {
            backButton.removeTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
            self.backAction = nil
        }
        
        layoutIfNeeded()
    }
    
    @objc private func backButtonTapped() {
        backAction?()
    }
}
