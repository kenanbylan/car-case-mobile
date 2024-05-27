//
//  FilterViewModel.swift
//  eteration-case
//
//  Created by Kenan Baylan on 26.05.2024.
//

import Foundation
import UIKit

enum SortOption: Int {
    case oldToNew = 0
    case newToOld
    case priceHighToLow
    case priceLowToHigh
}

final class FilterViewModel {
    var brands: [String] = ["Honda", "Samsung", "Huawei"]
    var models: [String] = ["Honda", "12 Pro", "13 Pro Max"]
    
    var filteredBrands: [String] = []
    var filteredModels: [String] = []
    
    var selectedBrands: [String] = []
    var selectedModels: [String] = []
    var selectedSortOption: SortOption = .oldToNew
    
    init() {
        filteredBrands = brands
        filteredModels = models
    }
    
    func filterBrands(searchText: String) {
        filteredBrands = searchText.isEmpty ? brands : brands.filter { $0.lowercased().contains(searchText.lowercased()) }
    }
    
    func filterModels(searchText: String) {
        filteredModels = searchText.isEmpty ? models : models.filter { $0.lowercased().contains(searchText.lowercased()) }
    }
    
    func toggleSelection(for item: String, in tableView: UITableView) {
        if tableView.restorationIdentifier == "brandTableView" {
            if let index = selectedBrands.firstIndex(of: item) {
                selectedBrands.remove(at: index)
            } else {
                selectedBrands.append(item)
            }
        } else {
            if let index = selectedModels.firstIndex(of: item) {
                selectedModels.remove(at: index)
            } else {
                selectedModels.append(item)
            }
        }
    }
    
    func isSelected(item: String, for tableView: UITableView) -> Bool {
        return tableView.restorationIdentifier == "brandTableView" ? selectedBrands.contains(item) : selectedModels.contains(item)
    }
}
