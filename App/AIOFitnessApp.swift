//
//  AIOFitnessApp.swift
//  AIOFitness
//
//  Created by Sergiu Lucaci on 29/12/2023.
//

import SwiftUI
import Firebase

@main
struct AIOFitnessApp: App {
    // State objects for managing app-wide data and functionality
    @StateObject var timermodel: TimerModel = .init()
    @StateObject var avm = AuthViewModel()
    @StateObject var manager = HealthManager()
    // Environment property to monitor the app's lifecycle phase
    @Environment(\.scenePhase) var phase
    // Timestamp to track the last active time of the app
    @State var lastActiveTimeStamp: Date = Date()
    // Initialize Firebase when the app starts
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            // Main content view of the app, incorporating necessary environment objects
            CTBView()
                .environmentObject(avm)
                .environmentObject(manager)
                .environmentObject(timermodel)
        }
        //background functionality for timer
        .onChange(of: phase) { newPhase, _ in
            if timermodel.isStarted {
                if newPhase == .background {
                    lastActiveTimeStamp = Date()
                }
                
                if newPhase == .active {
                    // Calculate the time difference since the app went to the background
                    let currentTimeStampDiff = Date().timeIntervalSince(lastActiveTimeStamp)
                    if timermodel.totalSeconds - Int(currentTimeStampDiff) <= 0 {
                        timermodel.isStarted = false
                        timermodel.isFinished = true
                        timermodel.totalSeconds = 0
                        
                    } else {
                        timermodel.totalSeconds -= Int(currentTimeStampDiff)
                    }
                }
            }
        }
    }
}
