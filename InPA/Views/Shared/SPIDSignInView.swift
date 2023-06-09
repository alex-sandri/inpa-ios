//
//  SPIDSignInView.swift
//  InPA
//
//  Created by Alex Sandri on 25/05/23.
//

import SwiftUI

struct SPIDSignInView: View {
    @State private var isWebViewLoading = true
    @State private var showSignInWebView = false

    @State private var selectedIdentityProvider: SPIDIdentityProvider? = nil

    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme: ColorScheme

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                    ForEach(SPIDIdentityProvider.allCases) { provider in
                        Button {
                            selectedIdentityProvider = provider
                        } label: {
                            Image(provider.displayName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30)
                                .frame(maxWidth: .infinity)
                                .accessibilityLabel(provider.displayName)
                        }
                        .controlSize(.large)
                        .buttonStyle(.borderedProminent)
                        .tint(colorScheme == .light ? Color(.systemGray6) : .white)
                    }
                }
                .onChange(of: selectedIdentityProvider) {
                    /*
                     Toggle this here as doing so inside of the button action
                     would show the view before the state has been actually updated.
                     */
                    showSignInWebView = true
                }
            }
            .padding(.horizontal)
            .navigationTitle("Accedi con SPID")
            .sheet(isPresented: $showSignInWebView) {
                if let selectedIdentityProvider {
                    try? SPIDSignInWebView(idp: selectedIdentityProvider) {
                        isWebViewLoading = false
                    } didSignIn: { accessToken in
                        showSignInWebView = false

                        await AuthStore.shared.setAccessToken(accessToken)

                        dismiss()
                    }
                    .overlay {
                        if isWebViewLoading {
                            ProgressView()
                        }
                    }
                    .onAppear {
                        isWebViewLoading = true
                    }
                }
            }
        }
    }
}

struct SPIDSignInView_Previews: PreviewProvider {
    static var previews: some View {
        SPIDSignInView()
    }
}
