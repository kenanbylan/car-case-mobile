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

final class FilterViewController: UIViewController {
    weak var delegate: FilterViewControllerDelegate?
    private let viewModel = FilterViewModel()
    
    private lazy var sortLabel: UILabel = {
        let label = UILabel()
        label.text = "Sort By"
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var sortStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var oldToNewButton: UIButton = createSortButton(title: "Old to new", tag: SortOption.oldToNew.rawValue)
    private lazy var newToOldButton: UIButton = createSortButton(title: "New to old", tag: SortOption.newToOld.rawValue)
    private lazy var priceHighToLowButton: UIButton = createSortButton(title: "Price high to low", tag: SortOption.priceHighToLow.rawValue)
    private lazy var priceLowToHighButton: UIButton = createSortButton(title: "Price low to high", tag: SortOption.priceLowToHigh.rawValue)
    
    private lazy var brandLabel: UILabel = {
        let label = UILabel()
        label.text = "Brand"
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var brandSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private lazy var brandTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "brandCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.restorationIdentifier = "brandTableView"
        return tableView
    }()
    
    private lazy var modelLabel: UILabel = {
        let label = UILabel()
        label.text = "Model"
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var modelSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private lazy var modelTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "modelCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.restorationIdentifier = "modelTableView"
        return tableView
    }()
    
    private lazy var applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Apply", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        setupConstraints()
        loadSelectedFilters()
    }
    
    private func setupViews() {
        view.addSubview(sortLabel)
        view.addSubview(sortStackView)
        
        [oldToNewButton, newToOldButton, priceHighToLowButton, priceLowToHighButton].forEach { button in
            sortStackView.addArrangedSubview(button)
        }
        
        view.addSubview(brandLabel)
        view.addSubview(brandSearchBar)
        view.addSubview(brandTableView)
        view.addSubview(modelLabel)
        view.addSubview(modelSearchBar)
        view.addSubview(modelTableView)
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
    
    private func createSortButton(title: String, tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.tag = tag
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(sortOptionChanged(_:)), for: .touchUpInside)
        return button
    }
    
    @objc private func sortOptionChanged(_ sender: UIButton) {
        [oldToNewButton, newToOldButton, priceHighToLowButton, priceLowToHighButton].forEach {
            $0.isSelected = false
            $0.backgroundColor = .gray
            $0.setTitleColor(.white, for: .normal)
        }
        sender.isSelected = true
        sender.backgroundColor = .systemBlue
        sender.setTitleColor(.white, for: .normal)
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
    
    private func loadSelectedFilters() {
        switch viewModel.selectedSortOption {
        case .oldToNew:
            oldToNewButton.isSelected = true
            oldToNewButton.backgroundColor = .systemBlue
            oldToNewButton.setTitleColor(.white, for: .normal)
        case .newToOld:
            newToOldButton.isSelected = true
            newToOldButton.backgroundColor = .systemBlue
            newToOldButton.setTitleColor(.white, for: .normal)
        case .priceHighToLow:
            priceHighToLowButton.isSelected = true
            priceHighToLowButton.backgroundColor = .systemBlue
            priceHighToLowButton.setTitleColor(.white, for: .normal)
        case .priceLowToHigh:
            priceLowToHighButton.isSelected = true
            priceLowToHighButton.backgroundColor = .systemBlue
            priceLowToHighButton.setTitleColor(.white, for: .normal)
        }
    }
    
}

// MARK: - UITableViewDataSource
extension FilterViewController: UITableViewDataSource {
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
}

// MARK: - UITableViewDelegate
extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = tableView == brandTableView ? viewModel.brands[indexPath.row] : viewModel.models[indexPath.row]
        viewModel.toggleSelection(for: item, in: tableView)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

// MARK: - UISearchBarDelegate
extension FilterViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar == brandSearchBar {
            viewModel.filterBrands(searchText: searchText)
            brandTableView.reloadData()
        } else {
            viewModel.filterModels(searchText: searchText)
            modelTableView.reloadData()
        }
    }
}
