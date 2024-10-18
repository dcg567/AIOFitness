//
//  TimerModel.swift
//  AIOFitness
//
//  Created by David Ghiurcan on 06/01/2024.
//
//  Some code segments have been sourced from third parties

import SwiftUI

class TimerModel: NSObject, ObservableObject {
    // Published properties for managing timer state
    @Published var progress: CGFloat = 1.0
    @Published var timerStringValue: String = "00:00"
    @Published var isStarted: Bool = false
    @Published var addNewTimer: Bool = false
    
    // Published properties for managing timer values
    @Published var minutes: Int = 0
    @Published var seconds: Int = 0
    
    // Published properties for managing total time and its static value
    @Published var totalSeconds: Int = 0
    @Published var staticTotalSeconds: Int = 0
    
    // Published property for tracking timer completion
    @Published var isFinished: Bool = false
    
    func startTimer(){
        withAnimation(.easeInOut(duration: 0.25)){isStarted = true}
        timerStringValue = "\(minutes >= 10 ? "\(minutes)":"0\(minutes)"):\(seconds >= 10 ? "\(seconds)":"0\(seconds)")"
        totalSeconds = (minutes * 60) + seconds
        staticTotalSeconds = totalSeconds
        addNewTimer = false
    }
    
    func stopTimer(){
        withAnimation{
            isStarted = false
            minutes = 0
            seconds = 0
            progress = 1
        }
        totalSeconds = 0
        staticTotalSeconds = 0
        timerStringValue = "00:00"
    }
    
    func updateTimer() {
        guard totalSeconds > 0 else {
            // Timer has reached 0
            isStarted = false
            isFinished = true
            return
        }

        totalSeconds -= 1
        progress = CGFloat(totalSeconds) / CGFloat(staticTotalSeconds)
        progress = max(progress, 0.0) // Ensure progress is not negative
        minutes = totalSeconds / 60
        seconds = totalSeconds % 60
        timerStringValue = String(format: "%02d:%02d", minutes, seconds)
    }

}
