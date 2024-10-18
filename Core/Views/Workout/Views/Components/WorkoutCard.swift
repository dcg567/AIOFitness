//
//  WorkoutCard.swift
//  AIOFitness
//
//  Created by David Ghiurcan on 08/01/2024.
//

import SwiftUI

struct WorkoutCard: View {
    let imageName: String
    let title: String
    let destination: String
    
    var body: some View {
        
        NavigationLink(destination: getDestinationView()) {
            ZStack {
                Rectangle()
                    .frame(width: 70, height: 20)
                    .padding()
                    .foregroundColor(.greyX2)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.greyX2)
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
                    )
                
                VStack {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                        .opacity(0.9)
                        .padding()
                        .padding(.leading, -50)
                }
                Text(title)
                    .font(.subheadline)
                    .bold()
                    .padding(.leading, 28)
                    .foregroundColor(.white)
                    .opacity(0.95)
                
            }
        }.preferredColorScheme(.dark)
    }
    //display correct exercises based on view
    func getDestinationView() -> some View {
        switch destination {
        case "ChestView":
            return AnyView(MuscleInfoView(muscleGroup: "Chest Exercises", exercises: ["Bench Press","Chest Press","Pec Deck","Chest Fly", "Dips" ], destination: ""))
        case "LegView":
            return AnyView(MuscleInfoView(muscleGroup: "Leg Exercises", exercises: ["Squat","Leg Press","RDL","Leg Extension", "Hamstring Curl", "Calf Raise", "Lunges"], destination: ""))
        case "ArmView":
            return AnyView(MuscleInfoView(muscleGroup: "Arm Exercises", exercises: ["Barbell Curl","Hammer Curl","Incline Curl", "Skull Crusher", "Pushdowns"], destination: ""))
        case "BackView":
            return AnyView(MuscleInfoView(muscleGroup: "Back Exercises", exercises: ["Pull Up", "Deadlift", "Lat Pulldown", "Barbell Row", "Machine Row", "T-Bar Row"], destination: ""))
        case "ShoulderView":
            return AnyView(MuscleInfoView(muscleGroup: "Delt Exercises", exercises: ["Lateral Raise", "Reverse Fly", "Shoulder Press", "Front Raise", "Military Press"], destination: ""))
        default:
            return AnyView(ProgressView())
        }
    }
}

struct WorkoutCard_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutCard(
            imageName: "armwo",
            title: "Chest",
            destination: "TrackWOView()"
        )
    }
}
