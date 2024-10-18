//
//  SettingsView.swift
//  AIOFitness
//
//  Created by David Ghiurcan on 29/12/2023.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        Button {
            viewModel.signOut()
        } label: {
            SettingsRowView(imageName: "arrow.left.circle.fill",
                            title: "Sign Out",
                            tintColor: .red)
        }
        Spacer()
    }
}

#Preview {
    SettingsView()
}
