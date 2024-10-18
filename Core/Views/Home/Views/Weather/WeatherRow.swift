//
//  WeatherRow.swift
//  AIOFitness
//
//  Created by Sergiu Lucaci on 18/01/2024.
//

import SwiftUI

// View that represents a single row of weather information
struct WeatherRow: View {
    var logo: String
    var name: String
    var value: String
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: logo)
                .font(.title2)
                .frame(width: 15, height: 15)
                .padding()
                .background(Color(.greenx2))
                .cornerRadius(50)
                       
            VStack(alignment: .leading, spacing: 8) {
                // The name of the weather data
                Text(name)
                    .font(.caption)
                    .foregroundColor(.white)
                
                // The value of the weather data
                Text(value)
                    .bold()
                    .font(.title)
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    WeatherRow(logo: "thermometer", name: "Feels like", value: "8°")
}
