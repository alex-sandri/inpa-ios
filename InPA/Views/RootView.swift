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

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .task {
                do {
                    await AuthStore.shared.load()
                    try await SavedForLaterStore.shared.load()
                } catch {
                    fatalError(error.localizedDescription)
                }
            }
    }
}
