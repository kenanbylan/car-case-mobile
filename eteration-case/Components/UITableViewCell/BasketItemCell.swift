//
//  BasketItemCell.swift
//  eteration-case
//
//  Created by Kenan Baylan on 25.05.2024.
//

import UIKit

final class BasketItemCell: UITableViewCell {
    static let identifier = "BasketItemCell"
    
    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var productPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var decrementButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("-", for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.addTarget(self, action: #selector(didTapDecrement), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var incrementButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.addTarget(self, action: #selector(didTapIncrement), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemBlue
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productNameLabel, productPriceLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [decrementButton, quantityLabel, incrementButton])
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [labelsStackView, buttonsStackView])
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
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
