//
//  CustomSleepView.swift
//  AIOFitness
//
//  Created by Sergiu Lucaci on 24/01/2024
//
//  Some code segments have been sourced from third parties

//Tabular regression is the task of predicting a numerical value given a set of attributes/features.

import CoreML
import SwiftUI

struct SleepView: View {
    @State private var wakeUpTime = defaultWakeUpTime
    @State private var sleepDuration = 8.0
    @State private var caffeineIntake = 100
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    static var defaultWakeUpTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Calculate My Sleep")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .fontWeight(.semibold)
                
                VStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Preferred Wake Up Time")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        DatePicker("Please select a time", selection: $wakeUpTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .frame(width: 90)
                            .padding(.leading, 220)
                            .padding(.top, -20)
                            .foregroundColor(.darkGrey)
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Desired Sleep Duration")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Stepper("\(sleepDuration.formatted()) hours", value: $sleepDuration, in: 4...12, step: 0.25)
                            .padding(.trailing, 20)
                    }
                    .padding(.top, 10)
                    .padding(.leading, 20)
                    .foregroundColor(.darkGrey)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Daily Caffeine Intake")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Stepper("\(caffeineIntake) mg of caffeine", value: $caffeineIntake, in: 100...2000, step: 100)
                            .padding(.trailing, 20)
                            .foregroundColor(.darkGrey)
                    }
                    .padding(.leading, 20)
                }
                .frame(width: 350, height: 200)
                .background(Color.greyX2)
                .cornerRadius(25)
                
                Button(action: {
                    calculateBedtime()
                }) {
                    ZStack {
                        Capsule()
                            .fill(Color.green)
                            .frame(width: 220, height: 55)
                        
                        HStack {
                            Image(systemName: "bed.double.fill")
                                .font(Font.system(size: 20))
                                .imageScale(.large)
                                .foregroundColor(.white)
                                .padding(.top, 2)
                                .padding(.bottom, 1)
                                .padding(.leading, -5)
                            
                            Text("Calculate")
                                .fontWeight(.semibold)
                                .font(.title)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.top, 25)
                }
            }
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
    
    private func calculateBedtime() {
        do {
            let configuration = MLModelConfiguration()
            let model = try SleepCalculator(configuration: configuration)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUpTime)
            let hour = (components.hour ?? 0) * 3600
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepDuration, coffee: Double(caffeineIntake))
            
            let sleepTime = wakeUpTime - prediction.actualSleep
            
            alertTitle = "Your Recommended Bedtime is"
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            alertTitle = "Error"
            alertMessage = "Failed to calculate bedtime: \(error.localizedDescription)"
            print("Error in calculating bedtime: \(error)")
        }
        
        showingAlert = true
    }
}

#Preview {
    SleepView()
}
