//
//  RegistrationView.swift
//  tester
//
//  Created by Sergiu Lucaci on 02/01/2024.
//
//  Some code segments have been sourced from third parties

import SwiftUI

struct RegistrationView: View {
    // State variables to hold form inputs
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        
        let containsLetter = password.rangeOfCharacter(from: .letters) != nil
        let containsDigit = password.rangeOfCharacter(from: .decimalDigits) != nil
        
        VStack {
            Image("aiofitness")
                .resizable()
                .scaledToFit()
                .frame(width:300, height: 250)
                .padding(.vertical, -10)
            
            // Form fields
            VStack(spacing: 24) {
                InputView(text: $email,
                          title: "Email Address",
                          placeholder: "name@example.com")
                .autocapitalization(.none)
                .foregroundColor(.green)
                
                InputView(text: $fullname,
                          title: "Full name",
                          placeholder: "Enter Your Name")
                
                // Password field with a trailing icon indicating password strength or requirements
                ZStack(alignment: .trailing) {
                    InputView(text: $password,
                              title: "Password",
                              placeholder: "Enter Your Password (ABC & 123)",
                              isSecureField: true)
                    
                    //  Display icons based on password validation
                    if containsLetter && containsDigit {
                        Image(systemName: "checkmark.circle.fill")
                            .imageScale(.large)
                            .fontWeight(.bold)
                            .foregroundColor(Color(.systemGreen))
                    }
                    if containsLetter && !containsDigit{
                        Image(systemName: "number.circle.fill")
                            .imageScale(.large)
                            .fontWeight(.bold)
                            .foregroundColor(Color.red)
                    }
                    if !containsLetter && containsDigit{
                        Image(systemName: "abc")
                            .imageScale(.small)
                            .fontWeight(.bold)
                            .foregroundColor(Color.red)
                    }
                }
                
                // Confirm password field with visual feedback
                ZStack(alignment: .trailing) {
                    InputView(text: $confirmPassword,
                              title: "Confirm Password",
                              placeholder: "Confirm your password",
                              isSecureField: true)
                    
                    // Visual feedback for password match
                    if !password.isEmpty && !confirmPassword.isEmpty {
                        if password == confirmPassword {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color.greenx2)
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color.red)
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            // Sign up button with action to create user
            Button {
                Task {
                    try await viewModel.createUser(withEmail: email, password: password, fullname: fullname)
                }
            } label: {
                HStack {
                    Text("SIGN UP")
                        .fontWeight(.semibold)
                    Image(systemName: "chevron.right")
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            }
            .background(Color.greenx2)
            .disabled(!formIsValid)
            .opacity(formIsValid ? 1.0: 0.5)
            .cornerRadius(10)
            .padding(.top, 24)
            
            Spacer()
        }
        .preferredColorScheme(.dark)
    }
}

// Extension to validate form inputs
extension RegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        let containsLetter = password.rangeOfCharacter(from: .letters) != nil
        let containsDigit = password.rangeOfCharacter(from: .decimalDigits) != nil
        // Ensure all fields meet the required criteria
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && confirmPassword == password
        && !fullname.isEmpty
        && containsLetter
        && containsDigit
    }
}

#Preview {
    RegistrationView()
}
