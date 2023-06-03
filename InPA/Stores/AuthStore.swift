//
//  AuthStore.swift
//  InPA
//
//  Created by Alex Sandri on 31/05/23.
//

import Foundation
import KeychainAccess

@MainActor
class AuthStore: ObservableObject {
    static let shared = AuthStore()

    private let keychain = Keychain()

    private init() {}

    @Published var isLoading = true

    @Published var user: User? = nil
    @Published var accessToken: String? = nil

    func load() async {
        self.accessToken = keychain["accessToken"]

        if let accessToken {
            do {
                let user = try await User.get(accessToken: accessToken)

                self.user = user
            } catch {
                self.accessToken = nil
            }
        } else {
            // Reset value if no access token is set (e.g.: on sign out)
            user = nil
        }

        isLoading = false
    }

    var isSignedIn: Bool {
        user != nil
    }

    func setAccessToken(_ value: String?) async {
        keychain["accessToken"] = value

        await load()
    }

    func signOut() async {
        await setAccessToken(nil)
    }
}
