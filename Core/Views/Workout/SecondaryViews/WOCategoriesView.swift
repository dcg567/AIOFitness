//
//  WOCategoriesView.swift
//  AIOFitness
//
//  Created by David Ghiurcan on 06/01/2024.
//

import SwiftUI
import Firebase

protocol FirestoreService {
    func getUserWorkouts(completion: @escaping ([DocumentSnapshotProtocol]?, Error?) -> Void)
}

protocol DocumentSnapshotProtocol {
    var data: [String: Any]? { get }
}

extension QueryDocumentSnapshot: DocumentSnapshotProtocol {
    var data: [String: Any]? {
        return self.data()
    }
}

class YourFirestoreService: FirestoreService {
    let firestoreDB = Firestore.firestore()

    func getUserWorkouts(completion: @escaping ([DocumentSnapshotProtocol]?, Error?) -> Void) {
        // Check if the current user is authenticated
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil, NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"]))
            return
        }
        
        // Reference to the user's workouts collection
        let userWorkoutsRef = firestoreDB.collection("workouts").document(userId).collection("user_workouts")
        
        // Fetch documents from the user's workouts collection
        userWorkoutsRef.getDocuments { (snapshot, error) in
            if let error = error {
                // Handle error
                completion(nil, error)
            } else {
                // Map snapshot documents to DocumentSnapshotProtocol objects
                let documents = snapshot?.documents.map { $0 as DocumentSnapshotProtocol }
                completion(documents, nil)
            }
        }
    }
}

struct WOCategoriesView: View {
    @State private var isShowingTimerView = false
    @State private var isShowingProgressView = false
    @State public var mostCommonWorkoutName: String?
    @State private var showSleepPopover = false
    let firestoreService: FirestoreService // Inject FirestoreService

        init(firestoreService: FirestoreService) {
            self.firestoreService = firestoreService
        }
        
    var body: some View {
        HStack {
            VStack {
                Text("Categories")
                    .foregroundColor(Color.white)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding()
                    .padding(.leading, 12)
            }.padding(.top, 1)
            
            Spacer()
            
            Button(action: {
                isShowingTimerView.toggle()
            }) {
                VStack {
                    Image(systemName: "clock")
                        .font(Font.system(size: 20))
                        .imageScale(.large)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.greenx2)
                        .shadow(color: Color.black.opacity(0.15), radius: 2, x: -2, y: 2)
                }.padding(.trailing, 30)
            }
            //timer popover toggle
            .popover(isPresented: $isShowingTimerView) {
                TimerView()
            }
        }.padding(.bottom, -15)
        HStack {
            Button(action: {
                isShowingProgressView.toggle()
            }) {
                HStack {
                    
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(Font.system(size: 12))
                        .imageScale(.large)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.greenx2)
                        .padding(.top, 2)
                        .padding(.bottom, 2)
                        .padding(.leading, 10)
                    
                    Text("View My Progress")
                        .font(Font.system(size: 20))
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                        .padding(.leading, 3)
                        .padding(.trailing, 90)
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 10))
                        .fontWeight(.semibold)
                        .foregroundColor(Color(.darkGrey))
                }
                .padding(.leading, -10)
            }
            //progress popup
            .popover(isPresented: $isShowingProgressView) {
                ProgresssView()
            }
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(Color.greyX2)
                    .frame(width: 340, height: 50)
                    .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 2)
            )
        }.padding(.top, 15)
            .padding(.bottom, 10)
        
        VStack{
            HStack {
                NavigationLink(destination: CardioView()) {
                    ZStack{
                        Text("     Cardio & Stretches")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color.darkGrey)
                        
                            .frame(width: 125, height: 55)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.greyX2)
                                    .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
                            )
                            .padding(.leading, 15)
                        
                        Image(systemName: "figure.strengthtraining.functional")
                            .font(Font.system(size: 12))
                            .imageScale(.large)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.greenx2)
                            .padding(.top, 2)
                            .padding(.bottom, 25)
                            .padding(.leading, -35)
                    }
                }.navigationTitle("")
                
                Button(action: {
                    showSleepPopover.toggle()
                }) {
                    ZStack{
                        Text("      Sleep Predictor")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color.darkGrey)
                            .frame(width: 125, height: 55)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.greyX2)
                                    .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
                            )
                            .padding()
                        
                        Image(systemName: "bed.double.fill")
                            .font(Font.system(size: 12))
                            .imageScale(.large)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.greenx2)
                            .padding(.top, 2)
                            .padding(.bottom, 25)
                            .padding(.leading, -42)
                    }
                }.popover(isPresented: $showSleepPopover) {
                    SleepView()
                }.preferredColorScheme(.dark)
            }
            HStack{
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.bGgrey)
                        .frame(width: 55, height: 55)
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                    
                    Image(systemName: "dumbbell.fill")
                        .font(Font.system(size: 20))
                        .imageScale(.large)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.darkGrey)
                        .shadow(color: Color(.systemGray4).opacity(0.2), radius: 3, x: -3, y: 7)
                        .rotationEffect(.degrees(-35))
                    
                }.padding(.leading, -70)
                
                VStack{
                    Text("Favourite Workout")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color.darkGrey)
                        .padding()
                        .padding(.leading, -30)
                        .padding(.bottom, 5)
                        .padding(.top, -2)
                    
                    Text(mostCommonWorkoutName ?? "None")
                        .font(.system(size: 24, weight: .semibold))
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.leading, -91)
                        .padding(.bottom, 12)
                        .padding(.top, -28)
                        .onAppear {
                            findMostCommonWorkoutName()
                        }
                
                }
                
            }.background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.greyX2)
                    .frame(width: 340, height: 75)
                    .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
            )
            .padding(.top, -20)
            .padding()
        } .accentColor(.greenx2)
    }
    public func findMostCommonWorkoutName() {
        firestoreService.getUserWorkouts { documents, error in
            guard let documents = documents, error == nil else {
                // Handle error
                print("Error fetching user workouts: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            // Dictionary to store counts of each workout name
            var workoutNameCount: [String: Int] = [:]
            print("Number of documents: \(documents.count)")
            
            // Iterate over each document and count the occurrences of each workout name
            for document in documents {
                if let userData = document.data {
                    if let workoutName = userData["workoutName"] as? String {
                        workoutNameCount[workoutName, default: 0] += 1
                    }
                }
            }
            
            if let mostCommonWorkoutName = workoutNameCount.max(by: { $0.1 < $1.1 })?.key {
                self.mostCommonWorkoutName = mostCommonWorkoutName
            } else {
                // Handle no workout names found
                print("No workout names found")
            }
        }
    }
}

#Preview {
    WorkOutView()
}

