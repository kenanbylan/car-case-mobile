//
//  HomeFilterHeader.swift
//  eteration-case
//
//  Created by Kenan Baylan on 26.05.2024.
//

import Foundation
import UIKit

protocol CollectionHeaderViewDelegate: AnyObject {
    func didTapSelectFilterButton()
}

final class CollectionHeaderView: UICollectionReusableView {
    static let identifier = "CollectionHeaderView"
    
    weak var delegate: CollectionHeaderViewDelegate?
    
    private let stackView = UIStackView()
    private let filterLabel = UILabel()
    private let selectFilterButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        filterLabel.text = "Filters"
        filterLabel.font = UIFont.systemFont(ofSize: 16)
        
        selectFilterButton.setTitle("Select Filter", for: .normal)
        selectFilterButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        selectFilterButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        selectFilterButton.addTarget(self, action: #selector(selectFilterButtonTapped), for: .touchUpInside)
        
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
