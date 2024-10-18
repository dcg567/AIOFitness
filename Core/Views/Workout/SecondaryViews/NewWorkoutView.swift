//
//  NewWorkoutView.swift
//  AIOFitness
//
//  Created by David Ghiurcan on 06/01/2024.
//

import SwiftUI

struct NewWorkoutView: View {
    var body: some View {
        ZStack {
                Rectangle()
                    .frame(width: 320, height: 275)
                    .padding()
                    .foregroundColor(.greyX2)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.greyX2)
                            .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 3))
            VStack{
                Image("chestwo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .opacity(0.9)
                    .padding()
                    
                HStack{
                    Text("Chest Pump")
                        .fontWeight(.semibold)
                        .font(.title)
                        .italic()
                        .padding(.trailing, 120)
                        .shadow(color: Color.black.opacity(0.15), radius: 3, x: -2, y: 2)
                        .foregroundColor(.white)
                    
                    Image(systemName: "play.fill")
                        .font(Font.system(size: 30))
                        .imageScale(.large)
                        .fontWeight(.bold)
                        .foregroundColor(Color(.white))
                        .shadow(color: Color.black.opacity(0.15), radius: 3, x: -2, y: 2)
                }.padding(.bottom)
            }
        }
    }
}

#Preview {
    NewWorkoutView()
}
