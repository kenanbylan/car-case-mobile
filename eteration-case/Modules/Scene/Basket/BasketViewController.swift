//
//  BasketViewController.swift
//  eteration-case
//
//  Created by Kenan Baylan on 25.05.2024.
//
import UIKit

final class BasketViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BasketViewModelDelegate {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BasketItemCell.self, forCellReuseIdentifier: BasketItemCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Complete", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var viewModel: BasketViewModelProtocol
    
    init(viewModel: BasketViewModelProtocol = BasketViewModel.shared) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTableView()
        setupFooterView()
        setupConstraints()
        addCustomHeader()
        updateTotalLabel()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
    }
    
    private func setupFooterView() {
        let stackView = UIStackView(arrangedSubviews: [totalLabel, completeButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let footerView = UIView()
        footerView.addSubview(stackView)
        footerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(footerView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: footerView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: footerView.bottomAnchor),
            
            completeButton.widthAnchor.constraint(equalToConstant: view.frame.width / 3),
            completeButton.heightAnchor.constraint(equalToConstant: 40),
            
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            footerView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60)
        ])
    }
    
    private func updateTotalLabel() {
        totalLabel.text = "Total: \(viewModel.totalPrice) ₺"
    }
    
    func onCartItemsUpdated() {
        tableView.reloadData()
        updateTotalLabel()
        updateTabBarBadge()
    }
    
    private func updateTabBarBadge() {
        if let tabItems = tabBarController?.tabBar.items {
            let basketTabItem = tabItems[1]
            basketTabItem.badgeValue = viewModel.cartItems.count > 0 ? "\(viewModel.cartItems.count)" : nil
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BasketItemCell.identifier, for: indexPath) as! BasketItemCell
        let cartItem = viewModel.cartItems[indexPath.row]
        cell.configure(with: cartItem)
        cell.onIncrement = { [weak self] in
            self?.viewModel.incrementQuantity(of: cartItem.toProduct())
        }
        cell.onDecrement = { [weak self] in
            self?.viewModel.decrementQuantity(of: cartItem.toProduct())
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
