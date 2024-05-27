//
//  HomeViewController.swift
//  eteration-case
//
//  Created by Kenan Baylan on 25.05.2024.

import UIKit
import Kingfisher

final class HomeViewController: UIViewController {
    
    private var viewModel: HomeViewModelProtocol?
    private var isLoading = false
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.size.width / 2 - 16, height: 300)
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        collectionView.register(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeaderView.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Products"
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        bindViewModel()
        viewModel?.fetchProducts()
        setupKeyboardDismissRecognizer()
        
        NotificationCenter.default.addObserver(self, selector: #selector(favoritesUpdated), name: .favoritesUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cartUpdated), name: .cartUpdated, object: nil)
        addCustomHeader(title: "E market")
    }
    
    private func setupViews() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel?.reloadCollectionView = { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    @objc private func favoritesUpdated() {
        collectionView.reloadData()
    }
    
    @objc private func cartUpdated() {
        collectionView.reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfItems ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
        if let product = viewModel?.product(at: indexPath) {
            cell.configure(with: product)
            cell.delegate = self
        }
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let product = viewModel?.product(at: indexPath) {
            let detailViewModel = DetailViewModel(product: product)
            let detailVC = DetailViewController(viewModel: detailViewModel)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
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
}

// MARK: UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.filterProducts(searchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: UIScrollViewDelegate
extension HomeViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            if !(viewModel?.isLoading ?? false) {
                viewModel?.fetchProducts()
            }
        }
    }
}

// MARK: ProductCellDelegate
extension HomeViewController: ProductCellDelegate {
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
}

// MARK: CollectionHeaderViewDelegate
extension HomeViewController: CollectionHeaderViewDelegate {
    func didTapSelectFilterButton() {
        let filterVC = FilterViewController()
        filterVC.delegate = self
        filterVC.modalPresentationStyle = .formSheet
        present(filterVC, animated: true, completion: nil)
    }
}

// MARK: FilterViewControllerDelegate
extension HomeViewController: FilterViewControllerDelegate {
    func didApplyFilters(brands: [String], models: [String], sortOption: SortOption) {
        viewModel?.applyFilters(brands: brands, models: models, sortOption: sortOption)
    }
}
