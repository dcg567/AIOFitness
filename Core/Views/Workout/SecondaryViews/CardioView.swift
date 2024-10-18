//
//  CardioView.swift
//  AIOFitness
//
//  Created by David Ghiurcan on 17/01/2024.
//

import SwiftUI

struct CardioView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    CardioCard(title: "Running ", effectiveness: "Moderate", timeRecommendation: "30-60 minutes", image: "figure.run", calCount: "240 - 480")
                    CardioCard(title: "Cycling ", effectiveness: "Moderate", timeRecommendation: "20-60 minutes", image: "figure.outdoor.cycle", calCount: "180 - 540")
                    CardioCard(title: "Jumping   ", effectiveness: "High", timeRecommendation: "15-30 minutes", image: "figure.jumprope", calCount: "175 - 350")
                    CardioCard(title: "Swimming ", effectiveness: "High", timeRecommendation: "30-60 minutes", image: "figure.pool.swim", calCount: "214 - 429")
                    CardioCard(title: "Threadmill", effectiveness: "Moderate", timeRecommendation: "20-45 minutes", image: "figure.walk", calCount: "230 - 490")
                }
                .padding()
            }
        }
    }
}
#Preview {
    CardioView()
}
