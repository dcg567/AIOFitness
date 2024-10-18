//
//  ContentView.swift
//  AIOFitness
//
//  Created by David Ghiurcan on 30/12/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                ProfileView()
            } else {
                LogInView()
            }
        }
        
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
