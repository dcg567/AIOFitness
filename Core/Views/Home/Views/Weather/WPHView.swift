//
//  WPHView.swift
//  AIOFitness
//
//  Created by Sergiu Lucaci on 28/03/2024.
//

import SwiftUI

// Placeholder view for WeatherView
struct WPHView: View {
    var body: some View {
        // Stacking content layers on top of each other
        ZStack(alignment: .leading) {
            ScrollView (.horizontal, showsIndicators: false) {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Loading")
                            .bold()
                            .font(.title)
                        
                        Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                            .fontWeight(.light)
                            .foregroundColor(.gray)
                        
                        VStack(spacing: 5) {
                            Image(systemName: "cloud")
                                .font(.system(size: 70))
                            
                            Text("Loading...")
                        }
                        .frame(width: 80, alignment: .leading)
                        .padding(.leading ,35)
                        .padding(.top ,30)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer(minLength: 30)
                    
                    Text("Loading...")
                        .font(.system(size: 120))
                        .fontWeight(.light)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing ,10)
            }
            
            ZStack {
                Color.greyX2
                    .cornerRadius(20)
                
                VStack(alignment: .leading, spacing: 40) {
                    Text("")
                        .bold()
                        .foregroundColor(.white)
                    
                    HStack {
                        Text("Loading...")
                        Spacer(minLength: 70)
                        Text("Loading...")
                    }
                    HStack {
                        Text("Loading...")
                        Spacer(minLength: 70)
                        Text("Loading...")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .foregroundColor(Color.white)
            }
            .padding(.top ,5)
            
        }.frame(height: 160)
            .frame(width: 360)
            .background(Color.greyX2)
            .cornerRadius(20)
    }
}

#Preview {
    WPHView()
}
