//
//  RootView.swift
//  InPA
//
//  Created by Alex Sandri on 03/06/23.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        AuthStateView {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                AccountView()
                    .tabItem {
                        Label("Account", systemImage: "person.crop.circle")
                    }
            }
        } signedOut: {
            HomeView()
        } loading: {
            ProgressView()
        }
    }
}

#Preview {
    RootView()
        .font(Font.custom("Titillium Web", size: 18))
        .task { await InPAApp.initialize() }
}
