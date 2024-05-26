//
//  BasketItemCell.swift
//  eteration-case
//
//  Created by Kenan Baylan on 25.05.2024.
//

import UIKit

final class BasketItemCell: UITableViewCell {
    static let identifier = "BasketItemCell"
    
    private let productNameLabel = UILabel()
    private let productPriceLabel = UILabel()
    private let decrementButton = UIButton(type: .system)
    private let incrementButton = UIButton(type: .system)
    private let quantityLabel = UILabel()
    
    var onIncrement: (() -> Void)?
    var onDecrement: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        productNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        productPriceLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        productPriceLabel.textColor = .systemBlue
        
        decrementButton.setTitle("-", for: .normal)
        incrementButton.setTitle("+", for: .normal)
        decrementButton.layer.cornerRadius = 5
        decrementButton.layer.borderWidth = 1
        decrementButton.layer.borderColor = UIColor.gray.cgColor
        incrementButton.layer.cornerRadius = 5
        incrementButton.layer.borderWidth = 1
        incrementButton.layer.borderColor = UIColor.gray.cgColor
        quantityLabel.backgroundColor = .systemBlue
        quantityLabel.textColor = .white
        quantityLabel.textAlignment = .center
        quantityLabel.layer.cornerRadius = 5
        quantityLabel.layer.masksToBounds = true
        
        decrementButton.addTarget(self, action: #selector(didTapDecrement), for: .touchUpInside)
        incrementButton.addTarget(self, action: #selector(didTapIncrement), for: .touchUpInside)
        
        let labelsStackView = UIStackView(arrangedSubviews: [productNameLabel, productPriceLabel])
        labelsStackView.axis = .vertical
        labelsStackView.spacing = 4
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonsStackView = UIStackView(arrangedSubviews: [decrementButton, quantityLabel, incrementButton])
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 4
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let mainStackView = UIStackView(arrangedSubviews: [labelsStackView, buttonsStackView])
        mainStackView.axis = .horizontal
        mainStackView.spacing = 16
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            quantityLabel.widthAnchor.constraint(equalToConstant: 44),
            quantityLabel.heightAnchor.constraint(equalToConstant: 44),
            decrementButton.widthAnchor.constraint(equalToConstant: 44),
            decrementButton.heightAnchor.constraint(equalToConstant: 44),
            incrementButton.widthAnchor.constraint(equalToConstant: 44),
            incrementButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func didTapDecrement() {
        onDecrement?()
    }
    
    @objc private func didTapIncrement() {
        onIncrement?()
    }
    
    func configure(with cartItem: BasketProduct) {
        productNameLabel.text = cartItem.name
        productPriceLabel.text = "\(cartItem.price) ₺"
        quantityLabel.text = "\(cartItem.quantity)"
    }
}
