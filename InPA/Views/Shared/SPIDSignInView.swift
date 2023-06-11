//
//  SPIDSignInView.swift
//  InPA
//
//  Created by Alex Sandri on 25/05/23.
//

#if os(macOS)
import AppKit
#endif
import SwiftUI

struct SPIDSignInView: View {
    @State private var isWebViewLoading = true
    @State private var showSignInWebView = false

    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                    ForEach(SPIDIdentityProvider.allCases) { provider in
                        NavigationLink {
                            try? SPIDSignInWebView(idp: provider) {
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
                        #if os(iOS)
                        .tint(colorScheme == .light ? Color(.systemGray6) : .white)
                        #elseif os(macOS)
                        .tint(colorScheme == .light ? Color(NSColor.controlColor) : .white)
                        #endif
                    }
                }
            }
            .padding(.horizontal)
            .navigationTitle("Accedi con SPID")
        }
    }
}

#Preview {
    SPIDSignInView()
}
