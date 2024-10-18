//
//  ExerciseDetailView.swift
//  AIOFitness
//
//  Created by David Ghiurcan on 16/01/2024.
//

import SwiftUI

struct ExerciseDetailView: View {
    let exercise: Exercise
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(exercise.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, -20)
                
                Image(exercise.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(30)
                    .frame(width: 250, height: 250)
                    .padding(.leading, 50)
                
                Text("Instructions:")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(exercise.instructions)
                    .foregroundColor(.darkGrey)
                    .lineLimit(nil)
                    .padding(.trailing, 10)
                
                Text("Optimal Sets & Reps:")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(exercise.repSetRange)
                    .foregroundColor(.darkGrey)
                    .italic()
            }
            .padding()
            
            Button(action: {
                // Open video link in browser
                if let url = URL(string: exercise.videoLink) {
                    UIApplication.shared.open(url)
                }
            }) {
                ZStack {
                    Capsule()
                        .foregroundColor(Color.greyX2)
                        .frame(maxWidth: 180, minHeight: 45)// Adjusted button bg color
                    
                    HStack {
                        Text("Watch Video")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Image(systemName: "play.fill")
                            .foregroundColor(.green)
                    }
                }

                .padding()
                .padding(.bottom, 10)
            }
        }
        
        
    }
}

#Preview {
    ExerciseDetailView(exercise: Exercise(
        
        name: "BENCH PRESS",
        imageName: "benchform",
        instructions: "Lie on a flat bench, grip the barbell with hands shoulder-width apart. ..",
        repSetRange: "3 sets x 5 - 8 reps",
        videoLink: "https://youtu.be/O-OBCfyh9Fw?si=fYSiZBai0sC2h6L0"))
}

struct Exercise {
    
    let name: String
    let imageName: String
    let instructions: String
    let repSetRange: String
    let videoLink: String
}
