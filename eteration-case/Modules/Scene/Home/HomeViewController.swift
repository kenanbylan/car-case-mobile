//
//  HomeViewController.swift
//  eteration-case
//
//  Created by Kenan Baylan on 25.05.2024.

import UIKit
import Kingfisher

final class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, ProductCellDelegate, CollectionHeaderViewDelegate, FilterViewControllerDelegate {
    
    private var collectionView: UICollectionView!
    private let searchBar = UISearchBar()
    private var viewModel = HomeViewModel()
    private var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSearchBar()
        setupCollectionView()
        bindViewModel()
        viewModel.fetchProducts()
        NotificationCenter.default.addObserver(self, selector: #selector(favoritesUpdated), name: .favoritesUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cartUpdated), name: .cartUpdated, object: nil)
        addCustomHeader(title: "E market")
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search Products"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.size.width / 2 - 16, height: 300)
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        collectionView.register(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeaderView.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.reloadCollectionView = { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
        cell.configure(with: viewModel.filteredProducts[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = viewModel.filteredProducts[indexPath.row]
        let detailViewModel = DetailViewModel(product: product)
        let detailVC = DetailViewController(viewModel: detailViewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionHeaderView.identifier, for: indexPath) as! CollectionHeaderView
            header.delegate = self
            return header
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterProducts(searchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    @objc private func favoritesUpdated() {
        collectionView.reloadData()
    }
    
    @objc private func cartUpdated() {
        collectionView.reloadData()
    }
    
    // MARK: - ProductCellDelegate
    
    func didTapAddToCart(product: Product) {
        BasketViewModel.shared.addToCart(product: product)
    }
    
    func didTapFavorite(product: Product, isFavorite: Bool) {
        if isFavorite {
            FavoriteViewModel().addToFavorites(product: product)
        } else {
            FavoriteViewModel().removeFromFavorites(product: product)
        }
    }
    
    // MARK: - CollectionHeaderViewDelegate
    
    func didTapSelectFilterButton() {
        // Present the modal filter view controller
        let filterVC = FilterViewController()
        filterVC.delegate = self
        filterVC.modalPresentationStyle = .formSheet
        present(filterVC, animated: true, completion: nil)
    }
    
    // MARK: - FilterViewControllerDelegate
    
    func didApplyFilters(brands: [String], models: [String], sortOption: SortOption) {
        viewModel.applyFilters(brands: brands, models: models, sortOption: sortOption)
    }
}
