//
//  CardioCard.swift
//  AIOFitness
//
//  Created by David Ghiurcan on 04/04/2024.
//

import SwiftUI

struct CardioCard: View {
    let title: String
    let effectiveness: String
    let timeRecommendation: String
    let image: String
    let calCount: String
    
    var body: some View {
        VStack {
            ZStack{
                Color(.greyX2)
                    .frame(height: 100)
                    .cornerRadius(25)
                
                HStack(spacing: 10){
                    Image(systemName: image)
                        .font(Font.system(size: 40))
                        .imageScale(.large)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.greenx2)
                        .padding(.leading, -50)
                    
                    Text(title)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .padding(.trailing, 15)
                }.padding(.trailing, 20)
                
                Color(.greyX2)
                    .frame(height: 20)
                    .padding(.top, 85)
            }
            VStack{
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Effectiveness:")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text(effectiveness)
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Time Recommendation:")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text(timeRecommendation)
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                HStack {
                    Image(systemName: "flame")
                        .bold()
                        .foregroundColor(.gray)
                    Text("Average caloires:")
                        .foregroundColor(.gray)
                        .bold()
                        .font(.headline)
                    Text(calCount)
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                }.padding(.leading, 20)
                    .cornerRadius(20)
                    .padding(.leading, -100)
                
            }.padding(.top, -10)
                .padding(.bottom)
                .padding(.leading, 5)
                .padding(.trailing, 5)
        }
        .background(Color.bGgrey)
        .cornerRadius(25)
        .shadow(radius: 5)
        .padding(.vertical)
    }
}
#Preview {
    CardioView()
}
