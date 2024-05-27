//
//  HomeFilterHeader.swift
//  eteration-case
//
//  Created by Kenan Baylan on 26.05.2024.
//

import UIKit

protocol CollectionHeaderViewDelegate: AnyObject {
    func didTapSelectFilterButton()
}

final class CollectionHeaderView: UICollectionReusableView {
    static let identifier = "CollectionHeaderView"
    
    weak var delegate: CollectionHeaderViewDelegate?
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var filterLabel: UILabel = {
        let label = UILabel()
        label.text = "Filters"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var selectFilterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Filter", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.addTarget(self, action: #selector(selectFilterButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(stackView)
        stackView.addArrangedSubview(filterLabel)
        stackView.addArrangedSubview(selectFilterButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    @objc private func selectFilterButtonTapped() {
        delegate?.didTapSelectFilterButton()
    }
}
