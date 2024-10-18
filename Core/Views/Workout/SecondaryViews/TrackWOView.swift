import SwiftUI
import Firebase

struct TrackWOView: View {
    @State private var exercises: [ExerciseEntry] = []
    @State private var newExerciseName = ""
    @State private var newWorkoutName = ""
    @State private var newSets = ""
    @State private var newReps = ""
    @State private var newWeight = ""
    @State private var completedWorkoutsCount = 0 // New state for completed workouts count
    @State private var selectedSortingOption: ExerciseSortingOption = .dateAdded //default sorting
    @State private var isListVisible = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("Exercise Card")
                    .font(.title)
                    .bold()
                    .padding(.leading, -170)
                    .padding(.bottom, -30)
                ExerciseFormView(newExerciseName: $newExerciseName, newWorkoutName: $newWorkoutName, newSets: $newSets, newReps: $newReps, newWeight: $newWeight, addExercise: addExercise, updateWorkoutCount: updateWorkoutCount)
                Button(action: {
                    withAnimation {
                        isListVisible.toggle()
                    }
                }) {
                    Text("View your added exercises & workouts below ↓")
                        .foregroundColor(.gray)
                        .italic()
                }
                if isListVisible {
                    // Create a List view to display exercises, with each exercise represented by an ExRow view
                    List(exercises) { exercise in
                        ExRow(exercise: exercise)
                    }.listStyle(PlainListStyle())
                        .background(Color.greyX2)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                // Create a menu with sorting options
                                Menu("Sort") {
                                    Button("Date Added (Most Recent)") { selectedSortingOption = .dateAdded }
                                    Button("Weight (Heavy -> Light)") { selectedSortingOption = .weight }
                                    Button("Alphabetical (Workouts)") { selectedSortingOption = .alphabetical }
                                }.foregroundColor(.white)
                            }
                        }
                }
            }
            .onAppear {
                print("View appeared, checking auth")
                // Check authentication state before loading exercises
                if let user = Auth.auth().currentUser {
                    print("User auth")
                    // User is authenticated, load exercises
                    fetchExercisesFromFirebase()
                    fetchCompletedWorkoutsCountFromFirebase() // Fetch completed workouts count
                } else {
                    print("User not auth")
                    // User is not authenticated, handle accordingly (e.g., show login screen)
                }
            }
            .onChange(of: selectedSortingOption) { newValue, _ in
                sortExercises()
                
            }
        }.preferredColorScheme(.dark)
    }
    
    func addExercise() {
        guard let userId = Auth.auth().currentUser?.uid,
              !newExerciseName.isEmpty,
              !newWorkoutName.isEmpty,
              !newSets.isEmpty,
              !newReps.isEmpty,
              !newWeight.isEmpty
        else {
            // Handle invalid input, show an alert, etc.
            return
        }
        
        let newExercise = ExerciseEntry(
            userId: userId,
            name: newExerciseName,
            workoutName: newWorkoutName,
            sets: newSets,
            reps: newReps,
            weight: newWeight
        )
        
        exercises.append(newExercise)
        
        // Clear input fields
        newExerciseName = ""
        newWorkoutName = ""
        newSets = ""
        newReps = ""
        newWeight = ""
        // Save to Firebase
        saveToFirebase(exercise: newExercise)
        // Increment completed workouts count
        
    }
    
    func updateWorkoutCount() {
        
        completedWorkoutsCount += 1
        updateCompletedWorkoutsCountInFirebase(count: completedWorkoutsCount)
    }
    
    func saveToFirebase(exercise: ExerciseEntry) {
        // Get a reference to the Firestore database
        let db = Firestore.firestore()
        // Reference to the "user_workouts" collection under the specific user's workouts collection
        let workoutsRef = db.collection("workouts").document(exercise.userId).collection("user_workouts")
        
        // Add a new document with data representing the exercise entry
        workoutsRef.addDocument(data: [
            "name": exercise.name!,
            "workoutName": exercise.workoutName!,
            "sets": exercise.sets!,
            "reps": exercise.reps!,
            "weight": exercise.weight!,
            "timestamp": FieldValue.serverTimestamp()// Server timestamp for when the data is added

        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added successfully")
            }
        }
    }
    
    func fetchExercisesFromFirebase() {
        // Ensure that a user is currently authenticated
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        
        // Reference to the "user_workouts" collection under the specific user's workouts collection
        let workoutsRef = db.collection("workouts").document(userId).collection("user_workouts")
        
        // Listen for changes in the documents within the "user_workouts" collection
        workoutsRef.addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                exercises = querySnapshot?.documents.compactMap { document in
                    if let name = document["name"] as? String,
                       let workoutName = document["workoutName"] as? String,
                       let sets = document["sets"] as? String,
                       let reps = document["reps"] as? String,
                       let weight = document["weight"] as? String,
                       let timestamp = document["timestamp"] as? Timestamp
                    {
                        return ExerciseEntry(
                            userId: userId,
                            name: name,
                            workoutName: workoutName,
                            sets: sets,
                            reps: reps,
                            weight: weight,
                            timestamp: timestamp
                        )
                    }
                    return nil
                } ?? []// If querySnapshot is nil, set exercises to an empty array

            }
        }
    }
    
    func fetchCompletedWorkoutsCountFromFirebase() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)
        
        userRef.getDocument { document, error in
            if let error = error {
                print("Error getting document: \(error)")
            } else if let document = document, document.exists {
                // If there are no errors and the document exists, extract the completed workouts count
                if let count = document.data()?["completedWorkouts"] as? Int {
                    completedWorkoutsCount = count
                }
            }
        }
    }
    
    func updateCompletedWorkoutsCountInFirebase(count: Int) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)
        
        userRef.updateData(["completedWorkouts": count]) { error in
            if let error = error {
                print("Error updating completed workouts count: \(error)")
            } else {
                print("Completed workouts count updated successfully")
            }
        }
    }
    private func sortExercises() {
        switch selectedSortingOption {
        case .dateAdded:
            // Sort exercises based on the timestamp (date added), with the most recent first
            exercises.sort { $0.timestamp?.dateValue() ?? Date() > $1.timestamp?.dateValue() ?? Date() }
        case .weight:
            // Sort exercises based on weight (if available), from heaviest to lightest
            exercises.sort { Int($0.weight ?? "0") ?? 0 > Int($1.weight ?? "0") ?? 0 }
        case .alphabetical:
            // Sort exercises alphabetically based on workout name
            exercises.sort { $0.workoutName ?? "" < $1.workoutName ?? "" }
        }
        withAnimation {
            exercises = exercises
        }
    }
}

struct ExerciseFormView: View {
    @Binding var newExerciseName: String
    @Binding var newWorkoutName: String
    @Binding var newSets: String
    @Binding var newReps: String
    @Binding var newWeight: String
    var addExercise: () -> Void
    var updateWorkoutCount: () -> Void
    @State private var showAlert = false
    
    var body: some View {
        //UI
        VStack(alignment: .leading, spacing: 16) {
            TextField("Workout Name", text: $newWorkoutName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocorrectionDisabled()
                .autocapitalization(.allCharacters)
                .lineLimit(1)
            
            TextField("Exercise Name", text: $newExerciseName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocorrectionDisabled()
                .autocapitalization(.words)
            HStack {
                TextField("Sets", text: $newSets)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Reps", text: $newReps)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            TextField("Weight (KG)", text: $newWeight)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            HStack {
                Button("Add to logbook", action: addExercise)
                    .padding()
                    .bold()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.15), radius: 3, x: -2, y: 2)
                    .opacity(
                        (newExerciseName.isEmpty || newSets.isEmpty || newReps.isEmpty || newWeight.isEmpty)
                        ? 0.35
                        : 1.0
                    )
                    .disabled(
                        newExerciseName.isEmpty || newSets.isEmpty || newReps.isEmpty || newWeight.isEmpty
                    )//button only works if all fields filled in
                Button("Finish Workout", action: {
                    updateWorkoutCount()
                    showAlert = true
                })
                .padding()
                .bold()
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.15), radius: 3, x: -2, y: 2)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Workout Completed"),
                        message: Text("Congratulations! Your workout has been logged ."),
                        dismissButton: .default(Text("OK")))
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.gray.opacity(0.2)))
        .padding()
    }
}
struct ExRow: View {
    var exercise: ExerciseEntry
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(exercise.workoutName ?? "")
                        .font(.subheadline)
                        .italic()
                        .foregroundColor(.green)
                        .lineLimit(1)
                }
                
                Text(exercise.name ?? "")
                    .font(.title2)
                    .fontWeight(.bold)
                    .lineLimit(1)
                
                HStack {
                    Text("Weight (KG):")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(exercise.weight ?? "")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Spacer()
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                
                if let timestamp = exercise.timestamp {
                    Text(formatTimestamp(timestamp: timestamp))
                        .font(.footnote)
                        .italic()
                        .foregroundColor(.white)
                        .lineLimit(1)
                }
                
                HStack {
                    Text("Set Number:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(exercise.sets ?? "")
                        .font(.subheadline)
                        .fontWeight(.bold)
                }
                
                HStack {
                    Text("Repetitions:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(exercise.reps ?? "")
                        .font(.subheadline)
                        .fontWeight(.bold)
                }
            }
            
            Spacer()
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemBackground)))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.systemGray4), lineWidth: 1))
    }
    
    private func formatTimestamp(timestamp: Timestamp) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy HH:mm"
        // Convert the Timestamp to a Date object, then format it into a string
        return dateFormatter.string(from: timestamp.dateValue())
    }
}

struct ExerciseEntry: Identifiable {
    var id = UUID()
    var userId: String
    var name: String?
    var workoutName: String?
    var sets: String?
    var reps: String?
    var weight: String?
    var timestamp: Timestamp?
}

enum ExerciseSortingOption {
    case dateAdded
    case weight
    case alphabetical
}

#Preview {
    TrackWOView()
    
}

