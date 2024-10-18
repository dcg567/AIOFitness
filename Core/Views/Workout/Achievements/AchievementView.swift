import SwiftUI
import Firebase
import Combine

struct AchievementsView: View {
    @State public var userWorkouts: [UserWorkout] = [] // Array to store workouts
    @State public var userProgress: Int = 0 // User progress (e.g total weight lifted)
    @State private var totalRepsCompleted: Int = 0 // Total reps completed by the user
    
    // Publisher for triggering view refresh
    let refreshPublisher = PassthroughSubject<Void, Never>()
    
    // Fetch user workouts from our Database
    func fetchUserWorkouts() {
        let db = Firestore.firestore()
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        
        db.collection("workouts")
            .document(currentUserID)
            .collection("user_workouts")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching user workouts: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No user workout documents found.")
                    return
                }
                
                self.userWorkouts = documents.compactMap { document -> UserWorkout? in
                    guard let repsString = document["reps"] as? String,
                          let reps = Int(repsString),
                          let setsString = document["sets"] as? String,
                          let sets = Int(setsString),
                          let weightString = document["weight"] as? String,
                          let weight = Double(weightString) else {
                        return nil
                    }
                    return UserWorkout(reps: reps, sets: sets, weight: weight)
                }
                
                // Calculate user progress based on fetched user workouts
                self.userProgress = self.calculateUserProgress()
                self.totalRepsCompleted = self.calculateTotalRepsCompleted()
                
                // Trigger view refresh
                self.refreshPublisher.send()
            }
    }
    
    // Calculate user progress based on fetched user workouts
    func calculateUserProgress() -> Int {
        return userWorkouts.reduce(0) { total, workout in
            total + (workout.reps * workout.sets * Int(workout.weight))
        }
    }
    
    // Calculate total reps completed based on fetched user workouts
    func calculateTotalRepsCompleted() -> Int {
        return userWorkouts.reduce(0) { $0 + ($1.reps * $1.sets) }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                Text("Achievements")
                    .foregroundStyle(Color.white)
                    .bold()
                    .font(.title)
                    .padding(.top, -5)
                    .padding(.bottom, -10)
                    .padding(.leading, 1)
                
                AchievementView(title: "If You Can't Lift...", desc: "Lift 10,000KG", isCompleted: userProgress >= 10000, progress: "\(userProgress)/10000 KG", imageName: "dumbbell", imageSize: CGSize(width: 48, height: 48), backgroundColor: .greyX2, borderColor: .greenx2).padding(.bottom, 10)
                    .padding(.top, 5)
                AchievementView(title: "Done Already? ", desc: "Complete 20 workouts", isCompleted: userWorkouts.count >= 20, progress: "\(userWorkouts.count)/20 Workouts", imageName: "bolt", imageSize: CGSize(width: 48, height: 48), backgroundColor: .greyX2, borderColor: .greenx2).padding(.bottom, 10)
                AchievementView(title: "Who's gonna carry these logs ", desc: "Do 300 repetitions", isCompleted: totalRepsCompleted >= 300, progress: "\(totalRepsCompleted)/300 Repetitions", imageName: "sportscourt", imageSize: CGSize(width: 48, height: 48), backgroundColor: .greyX2, borderColor: .greenx2).padding(.bottom, 10)
                AchievementView(title: "Jabba <3 ", desc: "Lift 100,000KG", isCompleted: userProgress >= 100000, progress: "\(userProgress)/100000 KG", imageName: "dumbbell", imageSize: CGSize(width: 48, height: 48), backgroundColor: .greyX2, borderColor: .greenx2).padding(.bottom, 10)
                AchievementView(title: "High Five ", desc: "Complete 100 workouts", isCompleted: userWorkouts.count >= 100, progress: "\(userWorkouts.count)/100 Workouts", imageName: "bolt", imageSize: CGSize(width: 48, height: 48), backgroundColor: .greyX2, borderColor: .greenx2).padding(.bottom, 10)
                AchievementView(title: "Mr. Worldwide ", desc: "Do 1500 repetitions", isCompleted: totalRepsCompleted >= 1500, progress: "\(totalRepsCompleted)/1500 Repetitions", imageName: "sportscourt", imageSize: CGSize(width: 48, height: 48), backgroundColor: .greyX2, borderColor: .greenx2).padding(.bottom, 10)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .onReceive(refreshPublisher) { _ in
                fetchUserWorkouts()
            }
            .onAppear {
                fetchUserWorkouts()
            }
        }
    }
}

#Preview {
    WorkOutView()
}

