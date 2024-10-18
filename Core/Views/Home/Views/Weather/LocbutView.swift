//
//  WelcomeView.swift
//  AIOFitness
//
//  Created by Sergiu Lucaci on 18/01/2024.
//

import SwiftUI
import CoreLocationUI

// A view that provides a button to request the current location using Core Location UI
struct LocbutView: View {
    @EnvironmentObject var locationManager: LocationManager
    
    
    var body: some View {
        VStack {
            
            // The location button that triggers location requests
            LocationButton(.shareCurrentLocation) {
                locationManager.requestLocation()
            }
            .symbolVariant(.fill)
            .labelStyle(.titleAndIcon)
            .cornerRadius(30)
            .foregroundColor(.greyX2)
            .tint(.greenx2)
            
        }
    }
}

#Preview {
    LocbutView()
}
