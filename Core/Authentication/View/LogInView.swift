import SwiftUI

struct LogInView: View {
    
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    Image("aiofitness")
                        .resizable()
                        .scaledToFit()
                        .frame(width:300, height: 250)
                        .padding(.vertical, 5)
                }
                //Form
                VStack(spacing: 24){
                    InputView(text: $email,
                              title: "Email Address",
                              placeholder: "mail@email.com")
                    .autocapitalization(.none)
                    .foregroundColor(.darkGrey)
                    
                    ZStack(alignment: .trailing) {
                        InputView(text: $password, title: "Password",
                                  placeholder: "Enter your password",
                                  isSecureField: !viewModel.isPasswordVisible)
                        
                        if !password.isEmpty {
                            Button(action: {
                                // Toggle password visibility
                                viewModel.togglePasswordVisibility()
                            }) {
                                Image(systemName: viewModel.isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                    .imageScale(.small)
                                    .foregroundColor(Color.greenx2)
                            }
                            .padding(.trailing, 8)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)
                //SignIn
                
                Button {
                    Task {
                        try await viewModel.signIn(withEmail: email, password: password)
                    }
                } label: {
                    HStack {
                        Text("SIGN IN")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color.greenx2)
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0: 0.5)
                .cornerRadius(10)
                .padding(.top, 24)
                
                if viewModel.isPasswordResetEmailSent {
                    Image(systemName: "envelope.fill")
                        .imageScale(.large)
                        .fontWeight(.bold)
                        .foregroundColor(Color.greenx2)
                        .padding(.top, 5)
                        .onAppear {
                            // Start a timer to change image back to text after 5 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                viewModel.isPasswordResetEmailSent = false
                            }
                        }
                } else {
                    Button {
                        Task {
                            if !email.isEmpty {
                                try await viewModel.resetPassword(forEmail: email)
                            } else {
                                print("DEBUG: Email address is empty.")
                                // Handle the case where the email address is empty
                            }
                        }
                    } label: {
                        Text("Forgot Password?")
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .padding(.top, 5)
                    }
                    .disabled(email.isEmpty)
                }

                Spacer()
                
                //SignUp
                NavigationLink {
                    RegistrationView()
                } label: {
                    HStack(spacing: 3){
                        Text("Dont have an account?")
                        Text("Sign up")
                            .fontWeight(.bold)
                    }.padding(.bottom)
                        .font(.system(size: 14))
                }.navigationTitle("")
            }
        }.preferredColorScheme(.dark)
            .ignoresSafeArea(.all)
    }
}

extension LogInView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
}

#Preview {
    LogInView()
}
