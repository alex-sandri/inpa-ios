//
//  InPAApp.swift
//  InPA
//
//  Created by Alex Sandri on 20/05/23.
//

import SwiftUI

@main
struct InPAApp: App {
    static func initialize() async {
        do {
            await AuthStore.shared.load()
            try await SavedForLaterStore.shared.load()
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .task { await InPAApp.initialize() }
        }

        #if os(macOS)
        Window("Accedi con SPID", id: "sign-in") {
            SPIDSignInView()
        }
        #endif
    }
}
