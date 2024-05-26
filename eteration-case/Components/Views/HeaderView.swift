//
//  HeaderView.swift
//  eteration-case
//
//  Created by Kenan Baylan on 25.05.2024.
//

import UIKit

final class HeaderView: UIView {
    private let titleLabel = UILabel()
    private let backButton = UIButton(type: .system)
    private let stackView = UIStackView()
    
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
        
        // Stack View
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        
        // Back Button
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = .white
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.isHidden = true // Initially hidden
        
        // Title Label
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 21)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        
        stackView.addArrangedSubview(backButton)
        stackView.addArrangedSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configure(title: String, showBackButton: Bool = false, backAction: (() -> Void)? = nil) {
        titleLabel.text = title
        backButton.isHidden = !showBackButton
        
        if showBackButton, let backAction = backAction {
            backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
            self.backAction = backAction
        }
    }
    
    @objc private func backButtonTapped() {
        backAction?()
    }
    
    private var backAction: (() -> Void)?
}
