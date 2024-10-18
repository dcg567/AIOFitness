//
//  FormSelectorView.swift
//  AIOFitness
//
//  Created by David Ghiurcan on 22/03/2024.
//

import SwiftUI

struct FormSelectorView: View {
    @State private var isCameraVisible = false
    @State private var isPopoverVisible = false // State to manage popover visibility

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    isCameraVisible.toggle()
                }) {
                    Text(isCameraVisible ? "Back" : "Check My Squat")
                        .padding()
                        .bold()
                        .foregroundColor(.white)
                        .background(Color.greenx2)
                        .cornerRadius(8)
                }
                .padding()
                
                
                
                if !isCameraVisible {
                    Image(systemName: "info.circle")
                        .padding(.leading, -10)
                        .font(.system(size: 20))
                        .foregroundColor(.greenx2)
                        .foregroundColor(.white)
                        .onTapGesture {
                            isPopoverVisible.toggle() // Toggle the popover visibility
                        }
                        .popover(isPresented: $isPopoverVisible,
                                 attachmentAnchor: .point(.leading),
                                 content: {
                            // Content of the popover
                            VStack {
                                Text("How to use")
                                    .underline()
                                    .font(.headline)
                                    .padding(.leading, -75)
                                    .padding(.bottom, -10)
                                Text("Ensure there is no background interference. Position yourself at least 1.5m from the camera. Tap check my form once you're in the correct position and perform a repetition.")
                                    .padding()
                                Spacer()
                                
                            }.frame(width: 200, height: 280)
                                .padding(.top)
                                .presentationCompactAdaptation(.none)
                        })
                }
            }
            Spacer()
            
            if isCameraVisible {
                Spacer()
                ViewControllerPreview()
                    .edgesIgnoringSafeArea(.all)
                    .edgesIgnoringSafeArea(.top)
                    .ignoresSafeArea(edges: .top)
            }
        }
            .accentColor(.greenx2)
    }
}

#Preview {
    FormSelectorView()
}
