//
//  HomeView.swift
//  AIOFitness
//
//  Created by Sergiu Lucaci on 08/01/2024.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var vm: AuthViewModel
    @EnvironmentObject var manager: HealthManager
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    @State var weather: ResponseBody?
    
    
    var body: some View {
        ZStack {
            Color.bGgrey
            VStack {
                HStack {
                    VStack {
                        Text(greeting())
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.leading, -124)
                        
                        // Shows the first name of the current user if available
                        if let user = vm.currentUser {
                            let firstName = user.fullname.components(separatedBy: " ").first ?? ""
                            Text(firstName + "!")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.leading, -174)
                        }
                    }
                    
                    // Shows the initials of the current user in a circle.
                    if let user = vm.currentUser {
                        Text(user.initials)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(Color(.systemGray))
                            .clipShape(Circle())
                            .padding(.leading, 65)
                            .padding(.trailing, -150)
                    }
                }
                .padding(.top, 25)
                
                // Main content with weather
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 1)) {
                    if locationManager.location == nil {
                        // Placeholder view when location data is not available
                        WPHView()
                    } else if let weather = weather {
                        // Displays the weather view if data is available
                        WeatherView(weather: weather)
                    } else {
                        LoadingView()
                            .task {
                                do {
                                    // Attempt to fetch weather data using the user's current location
                                    weather = try await weatherManager.getCurrentWeather(latitude: locationManager.location!.latitude, longitude: locationManager.location!.longitude)
                                } catch {
                                    print("Error getting weather: \(error)")
                                }
                            }
                    }
                    
                    // Loading view for when location data is being fetched
                    if locationManager.isLoading {
                        LoadingView()
                    } else {
                        HStack{
                            // Button view for location data
                            LocbutView()
                                .environmentObject(locationManager)
                                .opacity(locationManager.location != nil ? 0 : 1)
                        }.padding(.top,-155)
                            .padding(.leading, 0)
                    }
                }
                .padding(.horizontal)
                
                Text("Activities")
                    .font(.system(size: 25, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.leading, -175)
                    .padding(.top, -10)
                    .padding(.bottom, -5)
                
                // Grid of activity cards
                VStack {
                    LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2)) {
                        ForEach(manager.activities.sorted(by: { $0.value.id < $1.value.id }), id: \.key) { item in
                            ActivityCardView(activity: item.value)
                        }
                    }
                    .padding(.horizontal)
                }.padding(.bottom, -40)
                // Fetch health-related data on view appearance
                    .onAppear() {
                        manager.fetchTodaySteps()
                        manager.fetchTodayCalories()
                    }
            }
            .foregroundColor(.white)
            
            Spacer()
        }
        .ignoresSafeArea()
    }
    
    // Method to determine the appropriate greeting based on the time of day
    private func greeting() -> String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())
        
        switch hour {
        case 6..<12:
            return "Good Morning,   "
        case 12..<18:
            return "Good Afternoon,"
        default:
            return "Good Evening,    "
        }
    }
}


#Preview {
    let manager = HealthManager()
    manager.activities["todaySteps"] = Activity(id: 0, title: "Steps Taken Today", subtitle: "Goal: 1000", image: "figure.walk", amount: "545")
    manager.activities["todayCalories"] = Activity(id: 1, title: "Calories Burnt Today", subtitle: "Goal: 600", image: "flame", amount: "550")
    
    return HomeView()
        .environmentObject(AuthViewModel())
        .environmentObject(manager)
        .environmentObject(LocationManager())
}
