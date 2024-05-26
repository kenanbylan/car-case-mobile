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
    
    private(set) var brands: [String] = ["Honde", "Ford", "Toyota"]
    private(set) var models: [String] = ["Civic", "Focus", "Corolla"]
    
    var selectedBrands: [String] = []
    var selectedModels: [String] = []
    var selectedSortOption: SortOption = .oldToNew
    
    func filterBrands(searchText: String) {
        if searchText.isEmpty {
            brands = ["Honde", "Ford", "Toyota"]
        } else {
            brands = ["Honde", "Ford", "Toyota"].filter { $0.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    func filterModels(searchText: String) {
        if searchText.isEmpty {
            models = ["11", "12 Pro", "13 Pro Max"]
        } else {
            models = ["11", "12 Pro", "13 Pro Max"].filter { $0.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    func toggleSelection(for item: String, in tableView: UITableView) {
        if tableView == (tableView as? FilterViewController)?.brandTableView {
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
        if tableView == (tableView as? FilterViewController)?.brandTableView {
            return selectedBrands.contains(item)
        } else {
            return selectedModels.contains(item)
        }
    }
}
