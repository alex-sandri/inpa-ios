//
//  AuthStateView.swift
//  InPA
//
//  Created by Alex Sandri on 03/06/23.
//

import SwiftUI

struct AuthStateView<SignedInContent, SignedOutContent, LoadingContent>: View where SignedInContent: View, SignedOutContent: View, LoadingContent: View {
    let signedIn: () -> SignedInContent
    let signedOut: () -> SignedOutContent
    let loading: () -> LoadingContent

    @StateObject private var authStore = AuthStore.shared

    var body: some View {
        // HStack is needed as otherwise the view would not react with state changes
        HStack {
            if authStore.isLoading {
                loading()
            } else if authStore.isSignedIn {
                signedIn()
            } else {
                signedOut()
            }
        }
    }
}
