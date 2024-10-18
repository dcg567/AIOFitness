import XCTest
@testable import AIOFitness

class NutritionViewModelTests: XCTestCase {

    func testFetchRecipesSuccess() {
        // Given
        let viewModel = NutritionViewModel()
        let expectation = XCTestExpectation(description: "Recipes fetched successfully")
        
        // When
        viewModel.fetchRecipes()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { // Delay execution for 5 seconds to allow fetch to complete
            XCTAssertFalse(viewModel.recipes.isEmpty)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10) // Adjust timeout as needed
    }
    
    func testFetchRecipesInvalidURL() {
        // Given
        let viewModel = NutritionViewModel()
        let expectation = XCTestExpectation(description: "Invalid URL")
        
        // When
        viewModel.query = "" // Set invalid query to trigger invalid URL
        viewModel.fetchRecipes()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertTrue(viewModel.recipes.isEmpty) // Recipes should remain empty
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10) // Adjust timeout as needed
    }
}

