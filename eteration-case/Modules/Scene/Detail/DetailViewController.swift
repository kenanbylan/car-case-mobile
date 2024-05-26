//
//  DetailViewController.swift
//  eteration-case
//
//  Created by Kenan Baylan on 25.05.2024.
//

import UIKit
import Kingfisher

final class DetailViewController: UIViewController {
    
    private var viewModel: DetailViewModel!
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let imageView = UIImageView()
    private let favoriteButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let priceLabel = UILabel()
    private let addToCartButton = UIButton(type: .system)
    private let priceStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupScrollView()
        setupViews()
        setupConstraints()
        configureView()
        addCustomHeader(title: viewModel.product.name,showBackButton: true) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    init(viewModel: DetailViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupViews() {
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray
        contentView.addSubview(imageView)
        
        favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        favoriteButton.tintColor = .gray
        contentView.addSubview(favoriteButton)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 1
        contentView.addSubview(titleLabel)
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        contentView.addSubview(descriptionLabel)
        
        priceLabel.font = UIFont.boldSystemFont(ofSize: 18)
        priceLabel.textColor = .systemBlue
        
        addToCartButton.setTitle("Add to Cart", for: .normal)
        addToCartButton.setTitleColor(.white, for: .normal)
        addToCartButton.backgroundColor = .systemBlue
        addToCartButton.layer.cornerRadius = 5
        addToCartButton.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside) // Add action to the button
        
        priceStackView.axis = .horizontal
        priceStackView.spacing = 8
        priceStackView.alignment = .center
        priceStackView.distribution = .fill
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(addToCartButton)
        
        contentView.addSubview(priceStackView)
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        priceStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 70),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            
            favoriteButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            priceStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            priceStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            priceStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            priceStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            addToCartButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func configureView() {
        titleLabel.text = viewModel.product.name
        descriptionLabel.text = viewModel.product.description
        priceLabel.text = "Price: \(viewModel.product.price) ₺"
        
        if let url = viewModel.product.imageURL {
            imageView.kf.setImage(with: url)
        }
    }
    
    @objc private func addToCartButtonTapped() {
        BasketViewModel.shared.addToCart(product: viewModel.product)
        
        let alert = UIAlertController(title: "Success", message: "Product added to cart.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
