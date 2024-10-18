//
//  StretchView.swift
//  AIOFitness
//
//  Created by David Ghiurcan on 17/01/2024.
//
//remove?
import SwiftUI

struct StretchView: View {
    let stretches = [
        Stretch(name: "Hamstring Stretch", sets: "3 sets", duration: "30 seconds", image: "hs"),
        Stretch(name: "Chest Opener", sets: "2 sets", duration: "20 seconds", image: "str"),
        Stretch(name: "Quad Stretch", sets: "3 sets", duration: "25 seconds", image: "quad"),
        // Add more stretches as needed
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(stretches, id: \.id) { stretch in
                    StretchCard(stretch: stretch)
                }
            }
            .padding()
        }
    }
}

struct StretchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            StretchView()
        }
    }
}

struct StretchCard: View {
    let stretch: Stretch

    var body: some View {
        VStack {
            Image(stretch.image) 
                .resizable()
                .scaledToFill()
                .frame(height: 150)
                .cornerRadius(1)
                .opacity(0.3)
                .overlay(
                    Text(stretch.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding()
                )

            HStack {
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Sets: \(stretch.sets)")
                    Text("Duration: \(stretch.duration)")
                }
                .foregroundColor(.gray)
                .padding()
            }
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 5)
    }
}

struct Stretch {
    let id = UUID()
    let name: String
    let sets: String
    let duration: String
    let image: String
}


#Preview {
    StretchView()
}
