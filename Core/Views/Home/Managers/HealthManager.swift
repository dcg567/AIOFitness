//
//  HealthManager.swift
//  AIOFitness
//
//  Created by Sergiu Lucaci on 04/01/2024.
//
//  Some code segments have been sourced from third parties

import Foundation
import HealthKit
import UserNotifications

// An extension to the Date structure
extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
}

// This manager class handles health-related data and notifications
class HealthManager: NSObject, ObservableObject {
    
    // Interacts with the HealthKit store
    let healthStore = HKHealthStore()
    // Placeholder for step count observer query
    var observer: Any?
    
    // Stores activity data published to update the UI
    @Published var activities: [String: Activity] = [:]
    // Flag to track if notification has been sent
    var notificationSent = false
    // Store the last date when notification was sent
    internal var lastNotificationDate: Date? = nil
    
    override init() {
        super.init()
        
        // Defines the types of health data
        let steps = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let calories = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
        let flightsType = HKQuantityType.quantityType(forIdentifier: .flightsClimbed)!
        let healthTypes: Set<HKObjectType> = [steps, calories, distanceType, flightsType]
        
        // Requests notification authorisation from the user to send local notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("Notification authorization granted")
                UNUserNotificationCenter.current().delegate = self
            } else {
                print("Notification authorization denied")
            }
        }
        
        //  A task to request HealthKit authorisation and fetch initial data
        Task {
            do {
                // Request authorisation to access the specified health data types
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
                // Fetch initial health data
                fetchTodaySteps()
                fetchTodayCalories()
                fetchTodayDistanceWalked() // Call fetchTodayDistanceWalked
                fetchTodayFlightsClimbed() // Call fetchTodayFlightsClimbed
                startObservingSteps()
            } catch {
                print("Error requesting authorization")
            }
        }
    }
    
    // Fetch the number of steps taken today
    func fetchTodaySteps() {
        let steps = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let predicate = HKQuery.predicateForSamples(withStart: Date().startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let sum = result?.sumQuantity(), error == nil else {
                print("Error fetching today's step data")
                return
            }
            let stepCount = sum.doubleValue(for: HKUnit.count())
            let activity = Activity(id: 0, title: "Steps Taken Today", subtitle: "Goal: 10000", image: "shoeprints.fill", amount: stepCount.formattedString())
            
            DispatchQueue.main.async {
                self.activities["todaySteps"] = activity
                
                // Check if the step goal has been reached and if a notification has already been sent today
                if stepCount >= 10000 && !self.hasSentNotificationToday() {
                    self.sendStepCountNotification()
                    self.saveNotificationSentDate()
                }
            }
        }
        healthStore.execute(query)
    }
    
    // Check if a notification has been sent today
    private func hasSentNotificationToday() -> Bool {
        guard let lastNotificationDate = UserDefaults.standard.object(forKey: "HealthManager_lastNotificationDate") as? Date else {
            return false
        }
        return Calendar.current.isDateInToday(lastNotificationDate)
    }
    
    // Save the current date to track that a notification has been sent
    private func saveNotificationSentDate() {
        UserDefaults.standard.set(Date(), forKey: "HealthManager_lastNotificationDate")
    }
    
    // Fetch the number of calories burned today
    func fetchTodayCalories() {
        let calories = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        let predicate = HKQuery.predicateForSamples(withStart: Date().startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let sum = result?.sumQuantity(), error == nil else {
                print("Error fetching today's calorie data")
                return
            }
            let caloriesBurned = sum.doubleValue(for: .kilocalorie())
            let activity = Activity(id: 1, title: "Calories Burnt Today", subtitle: "Goal: 500", image: "flame", amount: caloriesBurned.formattedString())
            
            DispatchQueue.main.async {
                self.activities["todayCalories"] = activity
            }
            
            print(caloriesBurned.formattedString())
        }
        healthStore.execute(query)
    }
    
    // Fetch the distance walked today
    func fetchTodayDistanceWalked() {
        let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
        let predicate = HKQuery.predicateForSamples(withStart: Date().startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: distanceType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let sum = result?.sumQuantity(), error == nil else {
                print("Error fetching today's distance walked data")
                return
            }
            let distanceWalked = sum.doubleValue(for: .meter())
            let activity = Activity(id: 2, title: "Distance Walked Today", subtitle: "Goal: 5000", image: "figure.run", amount: distanceWalked.formattedString())
            
            DispatchQueue.main.async {
                self.activities["todayDistance"] = activity
            }
            
            print(distanceWalked.formattedString())
        }
        healthStore.execute(query)
    }
    
    // Fetch the number of flights climbed today
    func fetchTodayFlightsClimbed() {
        let flightsType = HKQuantityType.quantityType(forIdentifier: .flightsClimbed)!
        let predicate = HKQuery.predicateForSamples(withStart: Date().startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: flightsType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let sum = result?.sumQuantity(), error == nil else {
                print("Error fetching today's flights climbed data")
                return
            }
            let flightsClimbed = sum.doubleValue(for: .count())
            let activity = Activity(id: 3, title: "Flights Climbed Today", subtitle: "Goal: 10", image: "figure.stairs", amount: flightsClimbed.formattedString())
            
            DispatchQueue.main.async {
                self.activities["todayFlights"] = activity
            }
            
            print(flightsClimbed.formattedString())
        }
        healthStore.execute(query)
    }
    
    // Start observing step count changes and update health data
    func startObservingSteps() {
        let steps = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let observerQuery = HKObserverQuery(sampleType: steps, predicate: nil) { _, completionHandler, error in
            guard error == nil else {
                print("Error observing step count changes:", error!.localizedDescription)
                completionHandler()
                return
            }
            
            // Refresh step count and calories when changes are observed
            self.fetchTodaySteps()
            self.fetchTodayCalories()
            self.fetchTodayDistanceWalked()
            self.fetchTodayFlightsClimbed()
            
            completionHandler()
        }
        
        healthStore.execute(observerQuery)
    }
    
    // Stop observing step count changes
    func stopObservingSteps() {
        if let observer = observer {
            healthStore.stop(observer as! HKQuery)
        }
    }
    
    // Send a notification that the step goal has been reached
    func sendStepCountNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Congratulations!"
        content.body = "You've reached 10,000 steps today!"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "StepCountNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending notification: \(error.localizedDescription)")
            }
        }
    }
}

// UNUserNotificationCenterDelegate manages the behavior of notifications
extension HealthManager: UNUserNotificationCenterDelegate {
    // Handle foreground notification presentation
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Customise presentation options if needed
        completionHandler([.alert, .sound])
    }
    
    // Handle notification tap
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle notification tap actions if needed
        completionHandler()
    }
}

// An extension to format double values as strings with no decimal places
extension Double {
    func formattedString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}

