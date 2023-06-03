//
//  InPAApp.swift
//  InPA
//
//  Created by Alex Sandri on 20/05/23.
//

import SwiftUI

@main
struct InPAApp: App {
    var body: some Scene {
        WindowGroup {
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
}
