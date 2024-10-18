import XCTest
@testable import AIOFitness

// Define the Firestore service protocol
protocol FirestoreService {
    func getUserWorkouts(completion: @escaping ([DocumentSnapshotProtocol]?, Error?) -> Void)
}

// Define the Document snapshot protocol
protocol DocumentSnapshotProtocol {
    var data: [String: Any]? { get }
}

// Implement a mock document snapshot
class MockDocumentSnapshot: DocumentSnapshotProtocol {
    var data: [String: Any]?
    
    init(data: [String: Any]?) {
        self.data = data
    }
}

// Implement a mock Firestore service
class MockFirestoreService: FirestoreService {
    func getUserWorkouts(completion: @escaping ([DocumentSnapshotProtocol]?, Error?) -> Void) {
        let document1: [String: Any] = ["workoutName": "Arms"]
        let document2: [String: Any] = ["workoutName": "Legs"]
        let document3: [String: Any] = ["workoutName": "Legs"]
        let documents: [DocumentSnapshotProtocol] = [
            MockDocumentSnapshot(data: document1),
            MockDocumentSnapshot(data: document2),
            MockDocumentSnapshot(data: document3)
        ]
        completion(documents, nil)
    }
}

// Define your view model or SwiftUI view which uses the Firestore service
class WOCategoriesView {
    var firestoreService: FirestoreService
    var mostCommonWorkoutName: String?

    init(firestoreService: FirestoreService) {
        self.firestoreService = firestoreService
    }

    func findMostCommonWorkoutName() {
        firestoreService.getUserWorkouts { documents, error in
            guard let documents = documents, error == nil else {
                print("Error fetching user workouts: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            var workoutNameCount = [String: Int]()
            
            for document in documents {
                if let data = document.data, let workoutName = data["workoutName"] as? String {
                    workoutNameCount[workoutName, default: 0] += 1
                }
            }
            
            self.mostCommonWorkoutName = workoutNameCount.max(by: { $0.value < $1.value })?.key
        }
    }
}

// Unit tests for your Firestore interactions
class FirestoreServiceTests: XCTestCase {

    func testFindMostCommonWorkoutName() {
        let expectation = self.expectation(description: "Finding most common workout name")
        let mockFirestoreService = MockFirestoreService()
        let sut = WOCategoriesView(firestoreService: mockFirestoreService)

        sut.findMostCommonWorkoutName()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {  // Allow time for the async task to complete
            XCTAssertEqual(sut.mostCommonWorkoutName, "Legs", "The most common workout name should be 'Legs'")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5.0, handler: nil)
    }
}
