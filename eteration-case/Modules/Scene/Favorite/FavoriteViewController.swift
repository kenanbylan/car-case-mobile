//
//  FavoriteViewController.swift
//  eteration-case
//
//  Created by Kenan Baylan on 25.05.2024.
//

import UIKit

final class FavoriteViewController: UIViewController {
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private let viewModel = FavoriteViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTableView()
        setupBindings()
        viewModel.favoritesUpdated?()
        addCustomHeader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.favoritesUpdated?()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoriteProductCell.self, forCellReuseIdentifier: FavoriteProductCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.refreshControl = refreshControl
        view.addSubview(tableView)
        
        refreshControl.addTarget(self, action: #selector(refreshFavorites), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func refreshFavorites() {
        viewModel.fetchFavorites { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
    
    private func setupBindings() {
        viewModel.favoritesUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fetchFavoriteProducts().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteProductCell.identifier, for: indexPath) as! FavoriteProductCell
        let product = viewModel.fetchFavoriteProducts()[indexPath.row]
        cell.configure(with: product)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeFavorite(at: indexPath)
        }
    }
}
