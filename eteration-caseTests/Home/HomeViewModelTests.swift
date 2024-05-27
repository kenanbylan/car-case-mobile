//
//  HomeViewModelTests.swift
//  eteration-caseTests
//
//  Created by Kenan Baylan on 26.05.2024.
//

import XCTest
@testable import eteration_case

class HomeViewModelTests: XCTestCase {
    var viewModel: HomeViewModel!
    var mockNetworkManager: MockNetworkManager!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        viewModel = HomeViewModel(networkManager: mockNetworkManager)
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkManager = nil
        super.tearDown()
    }
    
    func testFetchProducts_Success() {
        // Given
        mockNetworkManager.fetchProductsResult = .success(mockProducts)
        
        // When
        let expectation = self.expectation(description: "Fetch products")
        viewModel.reloadCollectionView = {
            expectation.fulfill()
        }
        viewModel.fetchProducts()
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(viewModel.numberOfItems, mockProducts.count)
        XCTAssertEqual(viewModel.product(at: IndexPath(row: 0, section: 0))?.id, mockProducts[0].id)
    }
    
    func testFetchProducts_Failure() {
        // Given
        mockNetworkManager.fetchProductsResult = .failure(NSError(domain: "", code: -1, userInfo: nil))
        
        // When
        viewModel.fetchProducts()
        
        // Then
        XCTAssertEqual(viewModel.numberOfItems, 0)
    }
    
    func testFilterProducts() {
        // Given
        viewModel.filteredProducts = mockProducts
        
        // When
        viewModel.filterProducts(searchText: "Aston Martin Durango")
        
        // Then
        XCTAssertEqual(viewModel.numberOfItems, 1)
        XCTAssertEqual(viewModel.product(at: IndexPath(row: 0, section: 0))?.id, mockProducts[0].id)
    }
    
    func testApplyFilters() {
        // Given
        viewModel.filteredProducts = mockProducts
        
        // When
        viewModel.applyFilters(brands: ["Smart"], models: ["Roadster"], sortOption: .oldToNew)
        
        // Then
        XCTAssertEqual(viewModel.numberOfItems, 1)
        XCTAssertEqual(viewModel.product(at: IndexPath(row: 0, section: 0))?.id, mockProducts[0].id)
    }
}
