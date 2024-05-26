//
//  FilterViewController.swift
//  eteration-case
//
//  Created by Kenan Baylan on 25.05.2024.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func didApplyFilters(brands: [String], models: [String], sortOption: SortOption)
}

final class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    weak var delegate: FilterViewControllerDelegate?
    private let viewModel = FilterViewModel()
    
    private let sortLabel = UILabel()
    private let sortStackView = UIStackView()
    private let oldToNewButton = UIButton(type: .system)
    private let newToOldButton = UIButton(type: .system)
    private let priceHighToLowButton = UIButton(type: .system)
    private let priceLowToHighButton = UIButton(type: .system)
    
    private let brandLabel = UILabel()
     let brandSearchBar = UISearchBar()
     let brandTableView = UITableView()
    
    private let modelLabel = UILabel()
    private let modelSearchBar = UISearchBar()
    private let modelTableView = UITableView()
    
    private let applyButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        sortLabel.text = "Sort By"
        sortLabel.font = .boldSystemFont(ofSize: 16)
        sortLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sortLabel)
        
        sortStackView.axis = .vertical
        sortStackView.spacing = 8
        sortStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sortStackView)
        
        oldToNewButton.setTitle("Old to new", for: .normal)
        oldToNewButton.tag = 0
        oldToNewButton.addTarget(self, action: #selector(sortOptionChanged(_:)), for: .touchUpInside)
        
        newToOldButton.setTitle("New to old", for: .normal)
        newToOldButton.tag = 1
        newToOldButton.addTarget(self, action: #selector(sortOptionChanged(_:)), for: .touchUpInside)
        
        priceHighToLowButton.setTitle("Price high to low", for: .normal)
        priceHighToLowButton.tag = 2
        priceHighToLowButton.addTarget(self, action: #selector(sortOptionChanged(_:)), for: .touchUpInside)
        
        priceLowToHighButton.setTitle("Price low to high", for: .normal)
        priceLowToHighButton.tag = 3
        priceLowToHighButton.addTarget(self, action: #selector(sortOptionChanged(_:)), for: .touchUpInside)
        
        [oldToNewButton, newToOldButton, priceHighToLowButton, priceLowToHighButton].forEach { button in
            button.titleLabel?.font = .systemFont(ofSize: 14)
            button.setTitleColor(.black, for: .normal)
            button.setTitleColor(.systemBlue, for: .selected)
            sortStackView.addArrangedSubview(button)
        }
        
        brandLabel.text = "Brand"
        brandLabel.font = .boldSystemFont(ofSize: 16)
        brandLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(brandLabel)
        
        brandSearchBar.placeholder = "Search"
        brandSearchBar.delegate = self
        brandSearchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(brandSearchBar)
        
        brandTableView.delegate = self
        brandTableView.dataSource = self
        brandTableView.register(UITableViewCell.self, forCellReuseIdentifier: "brandCell")
        brandTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(brandTableView)
        
        modelLabel.text = "Model"
        modelLabel.font = .boldSystemFont(ofSize: 16)
        modelLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(modelLabel)
        
        modelSearchBar.placeholder = "Search"
        modelSearchBar.delegate = self
        modelSearchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(modelSearchBar)
        
        modelTableView.delegate = self
        modelTableView.dataSource = self
        modelTableView.register(UITableViewCell.self, forCellReuseIdentifier: "modelCell")
        modelTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(modelTableView)
        
        applyButton.setTitle("Apply", for: .normal)
        applyButton.setTitleColor(.white, for: .normal)
        applyButton.backgroundColor = .systemBlue
        applyButton.layer.cornerRadius = 5
        applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(applyButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            sortLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            sortLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            sortStackView.topAnchor.constraint(equalTo: sortLabel.bottomAnchor, constant: 8),
            sortStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            sortStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            brandLabel.topAnchor.constraint(equalTo: sortStackView.bottomAnchor, constant: 16),
            brandLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            brandSearchBar.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: 8),
            brandSearchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            brandSearchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            brandTableView.topAnchor.constraint(equalTo: brandSearchBar.bottomAnchor, constant: 8),
            brandTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            brandTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            brandTableView.heightAnchor.constraint(equalToConstant: 100),
            
            modelLabel.topAnchor.constraint(equalTo: brandTableView.bottomAnchor, constant: 16),
            modelLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            modelSearchBar.topAnchor.constraint(equalTo: modelLabel.bottomAnchor, constant: 8),
            modelSearchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            modelSearchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            modelTableView.topAnchor.constraint(equalTo: modelSearchBar.bottomAnchor, constant: 8),
            modelTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            modelTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            modelTableView.heightAnchor.constraint(equalToConstant: 100),
            
            applyButton.topAnchor.constraint(equalTo: modelTableView.bottomAnchor, constant: 16),
            applyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            applyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            applyButton.heightAnchor.constraint(equalToConstant: 44),
            applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func sortOptionChanged(_ sender: UIButton) {
        [oldToNewButton, newToOldButton, priceHighToLowButton, priceLowToHighButton].forEach { $0.isSelected = false }
        sender.isSelected = true
        viewModel.selectedSortOption = SortOption(rawValue: sender.tag) ?? .oldToNew
    }
    
    @objc private func applyButtonTapped() {
        delegate?.didApplyFilters(
            brands: viewModel.selectedBrands,
            models: viewModel.selectedModels,
            sortOption: viewModel.selectedSortOption
        )
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == brandTableView {
            return viewModel.brands.count
        } else {
            return viewModel.models.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableView == brandTableView ? "brandCell" : "modelCell", for: indexPath)
        let item = tableView == brandTableView ? viewModel.brands[indexPath.row] : viewModel.models[indexPath.row]
        cell.textLabel?.text = item
        cell.accessoryType = viewModel.isSelected(item: item, for: tableView) ? .checkmark : .none
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = tableView == brandTableView ? viewModel.brands[indexPath.row] : viewModel.models[indexPath.row]
        viewModel.toggleSelection(for: item, in: tableView)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar == brandSearchBar {
            viewModel.filterBrands(searchText: searchText)
        } else {
            viewModel.filterModels(searchText: searchText)
        }
    }
}
