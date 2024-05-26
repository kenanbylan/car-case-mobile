//
//  BasketViewController.swift
//  eteration-case
//
//  Created by Kenan Baylan on 25.05.2024.
//
import UIKit

final class BasketViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView = UITableView()
    private let totalLabel = UILabel()
    private let completeButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTableView()
        setupFooterView()
        setupConstraints()
        bindViewModel()
        addCustomHeader()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BasketItemCell.self, forCellReuseIdentifier: BasketItemCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
    }

    private func setupFooterView() {
        totalLabel.font = UIFont.boldSystemFont(ofSize: 18)
        totalLabel.text = "Total: \(BasketViewModel.shared.totalPrice) ₺"
        totalLabel.translatesAutoresizingMaskIntoConstraints = false

        completeButton.setTitle("Complete", for: .normal)
        completeButton.setTitleColor(.white, for: .normal)
        completeButton.backgroundColor = .systemBlue
        completeButton.layer.cornerRadius = 5
        completeButton.translatesAutoresizingMaskIntoConstraints = false

        let footerView = UIView()
        footerView.addSubview(totalLabel)
        footerView.addSubview(completeButton)
        footerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(footerView)

        NSLayoutConstraint.activate([
            totalLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            totalLabel.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),

            completeButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
            completeButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            completeButton.heightAnchor.constraint(equalToConstant: 44),
            completeButton.widthAnchor.constraint(equalToConstant: 100),

            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
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

    private func bindViewModel() {
        BasketViewModel.shared.onCartItemsUpdated = { [weak self] in
            self?.tableView.reloadData()
            self?.totalLabel.text = "Total: \(BasketViewModel.shared.totalPrice) ₺"
            self?.updateTabBarBadge()
        }
    }

    private func updateTabBarBadge() {
        if let tabItems = tabBarController?.tabBar.items {
            let basketTabItem = tabItems[1]
            basketTabItem.badgeValue = BasketViewModel.shared.cartItems.count > 0 ? "\(BasketViewModel.shared.cartItems.count)" : nil
        }
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BasketViewModel.shared.cartItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BasketItemCell.identifier, for: indexPath) as! BasketItemCell
        let cartItem = BasketViewModel.shared.cartItems[indexPath.row]
        cell.configure(with: cartItem)
        cell.onIncrement = { [weak self] in
            BasketViewModel.shared.incrementQuantity(of: cartItem.toProduct())
            self?.updateTabBarBadge()
        }
        cell.onDecrement = { [weak self] in
            BasketViewModel.shared.decrementQuantity(of: cartItem.toProduct())
            self?.updateTabBarBadge()
        }
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
