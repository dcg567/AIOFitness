//
//  WeatherView.swift
//  AIOFitness
//
//  Created by Sergiu Lucaci on 18/01/2024.
//

import SwiftUI

struct WeatherView: View {
    var weather: ResponseBody?
    
    var body: some View {
        if let weather = weather {
            // If weather data is present show the actual weather view
            ActualWeatherView(weather: weather)
        } else {
            // If weather data is not present show a placeholder
            WPHView()
        }
    }
}

// This function determines the appropriate weather icon based on the weather condition
func iconForWeatherCondition(_ condition: String) -> String {
    switch condition.lowercased() {
    case "clear":
        return "sun.max.fill"
    case "rain":
        return "cloud.rain.fill"
    case "thunderstorm":
        return "cloud.bolt.rain.fill"
    case "clouds":
        return "cloud.fill"
    case "snow":
        return "snow"
    case "mist", "smoke", "haze", "dust", "fog", "sand", "ash":
        return "cloud.fog.fill"
    default:
        return "questionmark.circle"
    }
}

// The view that displays the actual weather information
struct ActualWeatherView: View {
    var weather: ResponseBody
    
    var body: some View {
        ZStack(alignment: .leading) {
            ScrollView (.horizontal, showsIndicators: false) {
                HStack {
                    ZStack {
                        Color.greyX2
                            .cornerRadius(20)
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                // Displays the name of the location
                                Text(weather.name)
                                    .bold()
                                    .font(.title)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                                
                                // Displays the current date and time
                                Text("\(Date().formatted(.dateTime.month().day().hour().minute()))")
                                    .fontWeight(.light)
                                    .foregroundColor(.gray)
                                
                                // The icon and text indicating the current weather condition
                                VStack(spacing: 5) {
                                    Image(systemName: iconForWeatherCondition(weather.weather[0].main))
                                        .font(.system(size: 50))
                                    // The text description of the current weather
                                    Text("\(weather.weather[0].main)")
                                }
                                .frame(width: 80, alignment: .leading)
                                .padding(.leading ,10)
                            }.padding(.trailing, 30)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer(minLength: 10)
                            
                            // Displays the current temperature
                            Text(weather.main.feelsLike.roundDouble() + "°")
                                .font(.system(size: 100))
                                .fontWeight(.light)
                            
                        }.padding()
                            .padding(.trailing ,-10)
                        
                    }.padding(.trailing, 10)
                        .frame(height: 160)
                        .frame(width: 360)
                        .background(Color.greyX2)
                        .cornerRadius(20)
                    
                    ZStack{
                        Color.greyX2
                            .cornerRadius(20)
                        VStack {
                            VStack(alignment: .leading, spacing: 20) {
                                // The title text for the secondary weather information
                                Text("Weather now")
                                    .bold()
                                    .foregroundColor(.white)
                                    .padding(.bottom, -15)
                                
                                HStack {
                                    // The weather row for minimum temperature
                                    WeatherRow(logo: "thermometer", name: "Min temp", value: (weather.main.tempMin.roundDouble() + ("°")))
                                    Spacer(minLength: 40)
                                    // The weather row for maximum temperature
                                    WeatherRow(logo: "thermometer", name: "Max temp", value: (weather.main.tempMax.roundDouble() + "°"))
                                }
                                .padding(.bottom, -10)
                                
                                HStack {
                                    // The weather row for wind speed
                                    WeatherRow(logo: "wind", name: "Wind speed", value: (weather.wind.speed.roundDouble() + " m/s"))
                                    Spacer(minLength: 40)
                                    // The weather row for humidity
                                    WeatherRow(logo: "humidity", name: "Humidity", value: "\(weather.main.humidity.roundDouble())%")
                                }
                                .padding(.bottom, -15)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .foregroundColor(.black)
                        }
                        .padding(.trailing ,15)
                        .padding(.top ,-20)
                    }.frame(height: 160)
                        .frame(width: 360)
                        .background(Color.greyX2)
                        .cornerRadius(20)
                }
            }
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(weather: nil)
    }
}
