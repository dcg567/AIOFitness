//
//  FaqView.swift
//  AIOFitness
//
//  Created by Sergiu Lucaci on 09/04/2024.
//

import SwiftUI

struct FaqView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("FAQ")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                Text("Last updated: March 22, 2024")
                    .foregroundColor(.gray)
                
                Group {
                    Text("What is the purpose of the AIOFitness App's Privacy Policy?")
                        .font(.headline)
                    Text("The Privacy Policy informs users about the collection, use, and sharing of personal information upon using the AIOFitness App. It clarifies how data is protected and users' privacy rights.")
                    
                    Text("What kind of information does AIOFitness App collect?")
                        .font(.headline)
                    Text("AIOFitness App may collect personally identifiable information, such as your email address, for a better service experience. Log Data, like your browser's IP address and your activity within the service, may also be collected.")
                    
                    Text("How does AIOFitness App protect user information?")
                        .font(.headline)
                    Text("While no method is 100% secure, AIOFitness App strives to protect your personal information using commercially acceptable means. However, absolute security cannot be guaranteed.")
                    
                    Text("Does AIOFitness App share my personal information?")
                        .font(.headline)
                    Text("Your information is not shared with anyone except as described in the Privacy Policy. It's primarily used to improve the service and is protected against unauthorized access.")
                    
                    Text("Can AIOFitness App's Privacy Policy change?")
                        .font(.headline)
                    Text("Yes, the Privacy Policy may be updated over time. Users are advised to review the policy periodically for any changes. Updates will be effective immediately upon posting.")
                }
                .padding(.bottom, 10)
                
                Text("If you have further questions or suggestions about our Privacy Policy, do not hesitate to contact us.")
                    .padding(.bottom, 20)
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    FaqView()
}
