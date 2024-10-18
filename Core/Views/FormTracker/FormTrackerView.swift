import SwiftUI

struct FormTrackerView: View {
    @State private var isCameraVisible = false
    @State private var isPopoverVisible = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.bGgrey)
                //Bg takes up the whole screen
                    .ignoresSafeArea(.all)
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity)
                ScrollView {
                    HStack {
                        VStack(spacing: 20) {
                            //Title
                            Section(header: Text("Check My Form").font(.system(size: 36, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.trailing, 70)
                                .padding(.bottom, -10)
                                .padding(.leading, -35)
                                .padding(.top, 30)
                                .padding(.bottom, 5))
                            {
                            }
                            //Content
                            Section {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Analyse Your Squat Form")
                                        .font(.title3)
                                        .bold()
                                        .foregroundColor(.greenx2)
                                    
                                    Text("Get detailed feedback on your squat technique, including depth, posture, and more.")
                                        .font(.body)
                                        .foregroundColor(.gray)
                                        .frame(width: 320, height: 70, alignment: .leading)
                                }
                                .padding()
                                .background(Color.greyX2)
                                .cornerRadius(10)
                            }
                            // Subsection: How to Use
                            Section{
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Instructions for Using the Tracker")
                                        .font(.title3)
                                        .bold()
                                        .foregroundColor(.greenx2)
                                    
                                    Text("Ensure the user is postioned in front of the camera facing left or right. Step back so the user fits in the whole camera frame. Tap the camera button below to get started or click on the info button for more information")
                                        .font(.body)
                                        .foregroundColor(.gray)
                                        .frame(width: 320, height: 140, alignment: .leading)
                                }
                                .padding()
                                .background(Color.greyX2)
                                .cornerRadius(10)
                            }
                        }
                        .padding()
                    }
                    HStack {
                        //button toggles the camera
                        Button(action: {
                            isCameraVisible.toggle()
                        }) {
                            Circle()
                                .foregroundColor(Color.gray.opacity(0.15))
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Image(systemName: "camera.fill")
                                        .font(Font.system(size: 30))
                                        .imageScale(.large)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.greenx2)
                                        .shadow(color: Color.black.opacity(0.15), radius: 3, x: -2, y: 2)
                                )
                        }
                        .padding()
                        
                        Image(systemName: "info.circle")
                            .padding(.leading, -10)
                            .font(.system(size: 20))
                            .foregroundColor(.greenx2)
                            .foregroundColor(.white)
                            .padding(.top)
                            .offset(x: 5)
                    }.padding(.top, 50)
                        .padding(.leading, 20)
                }
                .padding(.top, 5)
                //ensures camera takes up the full screen rather than just small section
                if isCameraVisible {
                    VStack {
                        ViewControllerPreview()
                            .edgesIgnoringSafeArea(.all)
                            .edgesIgnoringSafeArea(.top)
                            .ignoresSafeArea(edges: .top)
                        Spacer()
                        Button("Dismiss Camera") {
                            withAnimation {
                                isCameraVisible = false
                            }
                        }
                        .padding()
                        .background(Color.greyX2)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                        .shadow(radius: 2)
                        .padding()
                    }
                }
            }
            
        }.preferredColorScheme(.dark)
            .accentColor(.greenx2)
    }
}

struct ViewControllerPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ViewController {
        return ViewController()
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
}

#Preview {
    FormTrackerView()
}
