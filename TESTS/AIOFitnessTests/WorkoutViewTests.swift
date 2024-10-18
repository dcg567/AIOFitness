import XCTest
import SwiftUI
import Combine
@testable import AIOFitness // Import your app module

//class WOCategoriesViewTests: XCTestCase {
//    
//    func testFavoriteWorkoutDisplayed() {
//        // Given
//        let view = WOCategoriesView(firestoreService: YourFirestoreService() as! FirestoreService)
//        let expectedWorkoutName = "Legs" // Assuming "Legs" is the expected favorite workout name based on a known dataset
//        
//        // When
//        view.findMostCommonWorkoutName()
//        // Then
//        XCTAssertNotEqual(name, expectedWorkoutName, "Favorite workout name should be displayed correctly")
//    }
//}

class TimerModelTests: XCTestCase {

    var timerModel: TimerModel!

    override func setUp() {
        super.setUp()
        timerModel = TimerModel()
    }

    override func tearDown() {
        timerModel = nil
        super.tearDown()
    }

    func testStartTimer() {
        // Given
        timerModel.minutes = 1
        timerModel.seconds = 30

        // When
        timerModel.startTimer()

        // Then
        XCTAssertTrue(timerModel.isStarted)
        XCTAssertEqual(timerModel.timerStringValue, "01:30")
        XCTAssertEqual(timerModel.totalSeconds, 90)
        XCTAssertEqual(timerModel.staticTotalSeconds, 90)
        XCTAssertFalse(timerModel.addNewTimer)
    }

    func testStopTimer() {
        // Given
        timerModel.isStarted = true
        timerModel.minutes = 1
        timerModel.seconds = 30
        timerModel.progress = 0.5

        // When
        timerModel.stopTimer()

        // Then
        XCTAssertFalse(timerModel.isStarted)
        XCTAssertEqual(timerModel.minutes, 0)
        XCTAssertEqual(timerModel.seconds, 0)
        XCTAssertEqual(timerModel.progress, 1.0)
        XCTAssertEqual(timerModel.totalSeconds, 0)
        XCTAssertEqual(timerModel.staticTotalSeconds, 0)
        XCTAssertEqual(timerModel.timerStringValue, "00:00")
    }

    func testUpdateTimer() {
        // Given
        timerModel.totalSeconds = 90
        timerModel.staticTotalSeconds = 90
        timerModel.minutes = 1
        timerModel.seconds = 30

        // When
        timerModel.updateTimer()
        
        print("Progress:", timerModel.progress)
        print("Total Seconds:", timerModel.totalSeconds)
        print("Timer String Value:", timerModel.timerStringValue)

        // Then
        XCTAssertEqual(timerModel.totalSeconds, 89)
        XCTAssertEqual(timerModel.progress, 89.0 / 90.0) // Assuming progress calculation
        XCTAssertEqual(timerModel.minutes, 1)
        XCTAssertEqual(timerModel.seconds, 29)
        XCTAssertEqual(timerModel.timerStringValue, "01:29")

        // Simulate timer reaching 0
        timerModel.totalSeconds = 0

        // When
        timerModel.updateTimer()

        // Then
        XCTAssertFalse(timerModel.isStarted)
        XCTAssertTrue(timerModel.isFinished)
    }
}
class ExerciseDetailViewBuilderTests: XCTestCase {

    // Add test case for default view
    func testGetDestinationViewForDefault() {
        let exercise = "Non-existing Exercise"
        let view = ExerciseDetailViewBuilder.getDestinationView(for: exercise)
        XCTAssertTrue(view is AnyView)
    
    }
}
