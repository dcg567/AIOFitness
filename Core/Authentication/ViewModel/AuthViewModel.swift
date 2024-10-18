//
//  AuthViewModel.swift
//  AIOFitness
//
//  Created by David Ghiurcan on 03/01/2024.
//
import Foundation
import Firebase
import FirebaseFirestoreSwift

//to define authentication form requirements
protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

// View model class for authentication functionality
@MainActor
class AuthViewModel: ObservableObject {
    
    // Published properties for UI updates
    @Published var navState: NavState = .log
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var isPasswordVisible = false
    @Published var isPasswordResetEmailSent = false
       
       func togglePasswordVisibility() {
           isPasswordVisible.toggle()
       }

    init() {
        self.userSession = Auth.auth().currentUser
        
        // Fetch user data asynchronously
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
            // Navigate to home screen if log in successful
            self.navState = .home
        } catch {
            print("DEBUG: Failed to log in with error \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            // Attempt user creation
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            self.navState = .home
            // Save user data to Firestore
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            // Clear user session and current user data
            self.userSession = nil
            self.currentUser = nil
            // Navigate to login screen
            self.navState = .log
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() {
        let user = Auth.auth().currentUser

        user?.delete { error in
            if let error = error {
                print("Error deleting account: \(error.localizedDescription)")
            } else {
                print("Account deleted successfully.")
                do {
                    try Auth.auth().signOut()
                    self.userSession = nil
                    self.currentUser = nil
                    self.navState = .log
                } catch {
                    print("Failed to sign out after deleting account: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func resetPassword(forEmail email: String) async throws {
        do {
            // Send password reset email
            try await Auth.auth().sendPasswordReset(withEmail: email)
            // Set the flag to indicate that the email was sent successfully
            self.isPasswordResetEmailSent = true
        } catch {
            // Handle error
            print("DEBUG: Failed to send password reset email with error \(error.localizedDescription)")
            // Optionally, reset the flag in case of failure
            self.isPasswordResetEmailSent = false
        }
    }
        
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        // Set current user data
        self.currentUser = try? snapshot.data(as: User.self)
    }
}
