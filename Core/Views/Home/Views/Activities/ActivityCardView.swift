//
//  ActivityCardView.swift
//  AIOFitness
//
//  Created by Sergiu Lucaci on 04/01/2024.
//

import SwiftUI

// Represents a single health or fitness activity
struct Activity {
    let id: Int
    let title: String
    let subtitle: String
    let image: String
    let amount: String
}

// A circular progress bar that visually represents progress
struct CircularProgressBar: View {
    var value: CGFloat
    var text: String
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 10))
                    .frame(width: geometry.size.width, height: geometry.size.height)
                
                // The foreground circle showing progress
                Circle()
                    .trim(from: 0, to: value)
                    .stroke(Color.green, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .rotationEffect(.degrees(-90))
                
                // The text showing the current value
                Text(text)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.green)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

// A linear progress bar that visually represents progress
struct LinearProgressBar: View {
    var value: CGFloat
    var text: String
    var body: some View {
        
        Text(text)
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(.green)
        
        // Use GeometryReader to size the bar with respect to the container
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .foregroundColor(Color.gray.opacity(0.3)) // Background color
                
                Rectangle()
                    .frame(width: geometry.size.width * value, height: geometry.size.height)
                    .foregroundColor(Color.green)
            }
        }
        .cornerRadius(5)
    }
}

// A card view representing an individual activity and its current progress
struct ActivityCardView: View {
    // The activity data to display
    @State var activity: Activity
    @State private var progress: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1)
                .cornerRadius(20)
            
            VStack(spacing: 20) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(activity.title)
                            .font(.system(size: 16))
                        
                        Text(activity.subtitle)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Image(systemName: activity.image)
                        .foregroundColor(.green)
                }
                
                // Display a circular progress bar for step and calories
                if activity.title == "Steps Taken Today" || activity.title == "Calories Burnt Today" {
                    CircularProgressBar(value: progress, text: activity.amount)
                        .frame(width: 100, height: 100)
                        .padding(.horizontal)
                    // Display a linear progress bar for distance and flights climbed
                } else if activity.title == "Distance Walked Today" || activity.title == "Flights Climbed Today" {
                    LinearProgressBar(value: progress, text: activity.amount)
                        .frame(width: 140, height: 10)
                        .padding(.top, -5)
                }
            }
            .padding()
        }.padding(.vertical, 5)
        // Calculate the progress when the view appears
            .onAppear {
                if activity.title == "Steps Taken Today" || activity.title == "Calories Burnt Today" {
                    progress = calculateProgress()
                } else if activity.title == "Distance Walked Today" || activity.title == "Flights Climbed Today" {
                    progress = calculateLinearProgress()
                }
            }
    }
    
    
    private func calculateProgress() -> CGFloat {
        guard let currentAmount = Float(activity.amount.replacingOccurrences(of: ",", with: "")),
              let goalAmount = Float(activity.subtitle.components(separatedBy: ": ")[1]) else {
            return 0.0
        }
        return CGFloat(min(currentAmount / goalAmount, 1.0))
    }
    
    private func calculateLinearProgress() -> CGFloat {
        // Print the activity data to check if it's correct
        print("Activity Title:", activity.title)
        print("Activity Subtitle:", activity.subtitle)
        print("Activity Amount:", activity.amount)
        
        // Extract the goal amount from the subtitle
        guard let goalAmountString = activity.subtitle.components(separatedBy: ": ").last,
              let goalAmount = Float(goalAmountString) else {
            print("Invalid goal amount format")
            return 0.0
        }
        
        // Extract the current amount from the activity amount
        guard let currentAmount = Float(activity.amount.replacingOccurrences(of: ",", with: "")) else {
            print("Invalid current amount format")
            return 0.0
        }
        
        // Calculate the progress based on current amount and goal amount
        let progress = CGFloat(min(currentAmount / goalAmount, 1.0))
        print("Calculated Progress:", progress)
        
        return progress
    }
}

struct ActivityCardView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityCardView(activity: Activity(id: 0, title: "Daily Steps", subtitle: "Goal: 1000", image: "figure.walk", amount: "545"))
    }
}
