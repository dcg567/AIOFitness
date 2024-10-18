import SwiftUI
import Firebase

struct LeaderboardUser: Identifiable {
    let id = UUID()
    let fullname: String
    let completedWorkouts: Int
    let initials: String // Add initials property
}

struct LeaderboardView: View {
    @State private var users: [LeaderboardUser] = []
    private let db = Firestore.firestore()

    var body: some View {
        NavigationView {
            List(users) { user in
                HStack {
                    Text(user.initials)
                    
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 52, height: 52)
                        .background(getBackgroundColor(for: user)) // Apply background color based on user's position
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    
                    VStack(alignment: .leading) {
                        Text("\(user.fullname)")
                            .font(.headline)
                            .bold()
                        Text("workouts completed: \(user.completedWorkouts)")
                            .font(.subheadline)
                            .foregroundColor(.darkGrey)
                    }.padding(.bottom, 10)
                        .padding(.top, 10)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Leaderboards")
            
            .scrollContentBackground(.hidden)
            .onAppear {
                fetchLeaderboardData()
            
            }
        }.preferredColorScheme(.dark)
    }

    private func fetchLeaderboardData() {
        db.collection("users")
            .order(by: "completedWorkouts", descending: true)
            .limit(to: 10)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching leaderboard data: \(error)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No user documents found.")
                    return
                }
                
                // Map the documents to LeaderboardUser objects
                users = documents.compactMap { document -> LeaderboardUser? in
                    guard let fullname = document["fullname"] as? String,
                          let completedWorkouts = document["completedWorkouts"] as? Int,
                          let initials = fullname.split(separator: " ").map({ $0.prefix(1) }).joined(separator: "") as Optional else {
                        return nil
                    }
                    return LeaderboardUser(fullname: fullname, completedWorkouts: completedWorkouts, initials: initials)
                }
            }
    }
    
    private func getBackgroundColor(for user: LeaderboardUser) -> Color {
        // Determine background color based on user's position in the leaderboard
        guard let topUser = users.first else { return .gray }
        switch user.id {
        case topUser.id:
            return .yellow // Gold for top user
        case users[1].id:
            return Color(red: 0.75, green: 0.75, blue: 0.75)//silver
        case users[2].id:
            return Color(red: 0.8, green: 0.5, blue: 0.2)//bronze
 
        default:
            return .gray
        }
    }
}

#Preview {
    LeaderboardView()
}

