//
//  ExRow.swift
//  AIOFitness
//
//  Created by David Ghiurcan on 04/04/2024.
//
import SwiftUI

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
//                        .padding()
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
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
    
    private func formatTimestamp(timestamp: Timestamp) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy HH:mm"
        return dateFormatter.string(from: timestamp.dateValue())
    }
    
}
