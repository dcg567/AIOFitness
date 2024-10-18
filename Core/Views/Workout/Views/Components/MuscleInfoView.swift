import SwiftUI

struct MuscleInfoView: View {
    let muscleGroup: String
    let exercises: [String]
    let titleColor: Color
    let backgroundColor: Color
    let destination: String
    
    init(muscleGroup: String, exercises: [String], titleColor: Color = .black, backgroundColor: Color = .white, destination: String) {
        self.muscleGroup = muscleGroup
        self.exercises = exercises
        self.titleColor = titleColor
        self.backgroundColor = backgroundColor
        self.destination = destination
    }
    
    var body: some View {
            VStack(alignment: .leading, spacing: 16) {

                    Text(muscleGroup)
                    .padding(.top, 10)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.greenx2)
                        .padding(.horizontal)
                // Scrollable list of exercises
                    ScrollView {
                        VStack(alignment: .leading, spacing: 22.5) {
                            ForEach(exercises, id: \.self) { exercise in
                                ExerciseRow(exercise: exercise)
                            }
                        }   
                        .padding(.horizontal)
                    }
            }.scrollIndicators(.hidden)
                .padding(.leading, 0)
                .padding()
                .frame(width: 340)
                .background(Color.bGgrey)
                .cornerRadius(20)
                .padding(.bottom)
    }
}

struct ExerciseRow: View {
    let exercise: String
    var body: some View {
        NavigationLink(destination: ExerciseDetailViewBuilder.getDestinationView(for: exercise)) {
            HStack{
                Text(exercise)
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                    .frame(width: 200)
                    .foregroundColor(.white)
                    .padding()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 10))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(.darkGrey))
                    .padding(.leading, -10)
                    .padding(.trailing, 12)
                
            }.background(RoundedRectangle(cornerRadius: 10).fill(Color.greyX2))
                .cornerRadius(10)
        }.navigationTitle("")
    }
    }
#Preview {
    MuscleInfoView(muscleGroup: "Test Exercises",
                   exercises: ["Squat", "Deadlift", "Row", "Hammer Curl"],
                   titleColor: .bGgrey,
                   backgroundColor: Color.white,
    destination: "ExerciseDetailView()")
}

