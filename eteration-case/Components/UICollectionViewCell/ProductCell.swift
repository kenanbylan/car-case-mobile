//
//  ProductCell.swift
//  eteration-case
//
//  Created by Kenan Baylan on 25.05.2024.
//

import UIKit
import Kingfisher

protocol ProductCellDelegate: AnyObject {
    func didTapAddToCart(product: Product)
    func didTapFavorite(product: Product, isFavorite: Bool)
}

final class ProductCell: UICollectionViewCell {
    static let identifier = "ProductCell"
    
    weak var delegate: ProductCellDelegate?
    private var product: Product?
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add to Cart", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
        contentView.layer.shadowRadius = 5
        setupViews()
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(priceLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(addToCartButton)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            
            favoriteButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8),
            
            priceLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            nameLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            addToCartButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            addToCartButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            addToCartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            addToCartButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            addToCartButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func favoriteButtonTapped() {
        guard let product = product else { return }
        let isCurrentlyFavorite = favoriteButton.tintColor == .systemYellow
        favoriteButton.tintColor = isCurrentlyFavorite ? .gray : .systemYellow
        favoriteButton.setImage(UIImage(systemName: isCurrentlyFavorite ? "star" : "star.fill"), for: .normal)
        delegate?.didTapFavorite(product: product, isFavorite: !isCurrentlyFavorite)
    }
    
    @objc private func addToCartButtonTapped() {
        if let product = product {
            delegate?.didTapAddToCart(product: product)
        }
    }
    
    public func configure(with product: Product) {
        self.product = product
        nameLabel.text = product.name
        priceLabel.text = "\(product.price) ₺"
        if let url = product.imageURL {
            imageView.kf.setImage(with: url)
        }
        updateFavoriteButton()
    }
    
    private func updateFavoriteButton() {
        guard let product = product else { return }
        let isFavorite = FavoriteViewModel().isFavorite(product: product)
        favoriteButton.tintColor = isFavorite ? .systemYellow : .gray
        favoriteButton.setImage(UIImage(systemName: isFavorite ? "star.fill" : "star"), for: .normal)
    }
}
