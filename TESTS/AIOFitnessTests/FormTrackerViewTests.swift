import XCTest
@testable import AIOFitness // Import your app module here

class ViewControllerTests: XCTestCase {
    
    var viewController: ViewController!
    
    override func setUp() {
        super.setUp()
        
        // Instantiate the view controller directly
        viewController = ViewController()
        // Load the view hierarchy
        viewController.loadViewIfNeeded()
    }
    
    override func tearDown() {
        super.tearDown()
        // Clean up resources
        viewController = nil
    }
    
    func testViewDidLoad() {
        // Test whether the view controller's view is loaded
        XCTAssertNotNil(viewController.view)
        // Assert that the video capture's predictor delegate is set to the view controller
        XCTAssertTrue(viewController.videoCapture.predictor.delegate === viewController)
    }
}

