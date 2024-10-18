import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @StateObject var locationManager = LocationManager()
    @State private var showDeleteConf = false
    @State private var showSignOutConf = false
    @State var weather: ResponseBody?
    
    // Instance of WeatherManager to fetch weather data
    var weatherManager = WeatherManager()
    var body: some View {
        if let user = viewModel.currentUser {
            NavigationView {
                List {
                    // User details section
                    Section {
                        HStack {
                            Text(user.initials)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 72, height: 72)
                                .background(Color(.systemGray3))
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.fullname)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.top, 4)
                                
                                Text(user.email)
                                    .font(.footnote)
                                    .accentColor(.gray)
                            }
                        }
                    }
                    
                    // General settings section
                    Section("General") {
                        SettingsRowView(imageName: "gear",
                                        title: "Version: 1.0.0",
                                        tintColor: Color(.systemGray))
                        .padding(.leading, -2)
                        
                        NavigationLink(destination: FaqView()){
                            SettingsRowView(imageName: "list.bullet.clipboard", title: "Frequently Asked Questions", tintColor: Color(.systemGray))
                        }.navigationTitle("")
                    }
                    
                    // Account management section
                    Section("Account") {
                        NavigationLink(destination: PrivacyView()){
                            SettingsRowView(imageName: "person", title: "Sharing & Privacy", tintColor: Color(.systemGray))
                        }.navigationTitle("")
                        
                        Button {
                            openAppSettings()
                        } label: {
                            SettingsRowView(imageName: "bell", title: "Push Notifications", tintColor: Color(.systemGray))
                        }
                        
                        Button {
                            showSignOutConf = true
                            
                        } label: {
                            SettingsRowView(imageName: "arrow.left.circle.fill",
                                            title: "Sign Out",
                                            tintColor: .greenx2)
                        }
                        
                        Button {
                            showDeleteConf = true
                        } label: {
                            SettingsRowView(imageName: "xmark.circle.fill",
                                            title: "Delete Account",
                                            tintColor: .greenx2)
                        }
                    }
                }
            }
            // Configure alerts based on the state for sign out or delete account confirmation
            .alert(isPresented: .constant(showDeleteConf || showSignOutConf)) {
                if showDeleteConf {
                    return Alert(
                        title: Text("Delete Account"),
                        message: Text("Are you sure you want to delete your account?"),
                        primaryButton: .destructive(Text("Yes")) {
                            viewModel.deleteAccount()
                        },
                        secondaryButton: .cancel(Text("No")) {
                            showDeleteConf = false // Dismiss the alert
                        }
                    )
                } else {
                    return Alert(
                        title: Text("Sign Out"),
                        message: Text("Are you sure you want to sign out?"),
                        primaryButton: .destructive(Text("Yes")) {
                            viewModel.signOut()
                        },
                        secondaryButton: .cancel(Text("No")) {
                            showSignOutConf = false // Dismiss the alert
                        }
                    )
                }
            }.preferredColorScheme(.dark)
        }
    }
}

// Function to open app specific settings in the settings app
func openAppSettings() {
    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
    UIApplication.shared.open(settingsUrl)
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        // Mock user and viewModel setup for previews
        let user = User(id: "dedlewdl", fullname: "John Doe", email: "john@example.com")
        let viewModel = AuthViewModel()
        viewModel.currentUser = user
        
        return ProfileView()
            .environmentObject(viewModel)
    }
}

