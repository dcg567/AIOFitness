//
//  User.swift
//  AIOFitness
//
//  Created by David Ghiurcan on 03/01/2024.
//
import Foundation

// Define a struct representing a user, conforming to Identifiable and Codable protocols
struct User: Identifiable, Codable {
    let id: String
    let fullname: String
    let email: String
    
    // Computed property to generate initials from the user's full name
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}
// Extension to the User struct to provide a mock user for testing purposes
extension User {
    static var MOCK_USER = User(id: NSUUID().uuidString, fullname: "Test Account", email: "test@aiofitness.com")
}
