import SwiftUI

// Define UserWorkout model
struct UserWorkout: Identifiable {
    let id = UUID() // Added id property
    let reps: Int
    let sets: Int
    let weight: Double
    
    // Explicit initialiser
    init(reps: Int, sets: Int, weight: Double) {
        self.reps = reps
        self.sets = sets
        self.weight = weight
    }
}
