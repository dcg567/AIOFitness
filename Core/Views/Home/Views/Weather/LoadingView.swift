//
//  LoadingView.swift
//  AIOFitness
//
//  Created by Sergiu Lucaci on 18/01/2024.
//

import SwiftUI

// Defines a view for displaying a loading indicator
struct LoadingView: View {
    var body: some View {
        // Using ProgressView a built in SwiftUI view for displaying progress
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    LoadingView()
}
