import SwiftUI
import Firebase

struct ProgresssView: View {
    @State private var selectedDate = Date()
    @State private var workoutDays: [Date] = []
    @State private var exercisesCount = 0
    @State private var completedWorkoutsCount = 0
    @State private var mostCommonWorkoutName: String?

    var body: some View {
        ZStack {
            Color(.bGgrey)
                .ignoresSafeArea(.all)
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
            VStack {
                Text("Workout Progress Chart")//Title
                    .font(.title)
                    .foregroundColor(.white)
                    .bold()
                    .padding()
                    .padding(.leading, -10)
                
                Text(formatDate(selectedDate, format: "MMMM yyyy"))
                    .font(.headline)
                    .foregroundColor(Color(.darkGrey))
                    .padding(.bottom, -20)
                    .padding(.leading, -160)
                    .padding(.top, -10)
                    .onTapGesture {
                    }
                
                ScrollView(.horizontal) {
                    Graph(workoutDays: workoutDays, selectedDate: $selectedDate)
                        .foregroundColor(.white)
                        .frame(height: 300)
                        .padding(.top, -10)
                        .padding(.bottom, -1)
                }
                
                HStack(spacing: 16) {
                    VStack {
                        // Display number of exercises added
                        Text("Exercises Added")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color.greenx2)
                            .cornerRadius(8)
                        
                        Text("\(exercisesCount)")
                            .font(.title)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(.greyX2)))
                    
                    VStack {
                        // Display number of completed workouts
                        Text("Workouts Completed")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color.greenx2)
                            .cornerRadius(8)
                        
                        Text("\(completedWorkoutsCount)")
                            .font(.title)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(.greyX2)))

                }
                .padding()
                .padding(.bottom, 60)
                
                VStack {
                    // Display most common workout name
                    Text("Favourite Workout")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color.greenx2)
                        .cornerRadius(8)
                    
                    Text(mostCommonWorkoutName ?? "Loading...")
                        .font(.title)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .onAppear {
                            findMostCommonWorkoutName { name in
                                mostCommonWorkoutName = name
                            }
                        }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.greyX2)))
                .padding()
                .padding(.leading, 5)
                .padding(.trailing, 5)
                .padding(.top, -75)
            }
            .padding()
            .onAppear {
                // Fetch initial data when the view appears
                fetchWorkoutDays()
                fetchExercisesCount()
                fetchCompletedWorkoutsCount()
            }
        }
    }
    // Fetch the count of completed workouts from Firestore
    private func fetchCompletedWorkoutsCount() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)
        
        userRef.getDocument { document, error in
            if let error = error {
                print("Error getting document: \(error)")
            } else if let document = document, document.exists {
                if let count = document.data()?["completedWorkouts"] as? Int {
                    completedWorkoutsCount = count
                }
            }
        }
    }
    private func fetchWorkoutDays() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }

        let db = Firestore.firestore()
        
        // Reference to the user's workout collection
        let workoutsRef = db.collection("workouts").document(userId).collection("user_workouts")

        workoutsRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                let fetchedWorkoutDays = querySnapshot?.documents.compactMap { document in
                    if let timestamp = document["timestamp"] as? Timestamp {
                        return timestamp.dateValue()
                    }
                    return nil
                } as? [Date] ?? []

                // Update the @State variable or trigger UI update on the main thread
                DispatchQueue.main.async {
                    workoutDays = fetchedWorkoutDays.sorted() // Ensure dates are sorted
                }
            }
        }
    }

    private func fetchExercisesCount() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        let db = Firestore.firestore()
        let workoutsRef = db.collection("workouts").document(userId).collection("user_workouts")

        workoutsRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                let count = querySnapshot?.documents.count ?? 0

                // Update the @State variable or trigger UI update on the main thread
                DispatchQueue.main.async {
                    exercisesCount = count
                }
            }
        }
    }

    private func findMostCommonWorkoutName(completion: @escaping (String?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }

        let db = Firestore.firestore()
        let workoutsRef = db.collection("workouts").document(userId).collection("user_workouts")

        workoutsRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(nil)
            } else {
                // Extract workout names from the fetched documents and count their occurrences
                guard let documents = querySnapshot?.documents else {
                    // If no documents found, call the completion handler with nil and return
                    completion(nil)
                    return
                }

                var workoutNameCount: [String: Int] = [:]
                // Iterate through the documents and count workout name occurrences
                for document in documents {
                    if let workoutName = document["workoutName"] as? String {
                        workoutNameCount[workoutName, default: 0] += 1
                    }
                }
                // Find the most common workout name based on occurrence count
                if let mostCommonWorkoutName = workoutNameCount.max(by: { $0.1 < $1.1 })?.key {
                    completion(mostCommonWorkoutName)
                } else {
                    completion(nil)
                }
            }
        }
    }
  
    private func formatDate(_ date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}

#Preview {
    ProgresssView()
}

