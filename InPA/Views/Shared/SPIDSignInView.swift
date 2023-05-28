//
//  SPIDSignInView.swift
//  InPA
//
//  Created by Alex Sandri on 25/05/23.
//

import SwiftUI

struct SPIDSignInView: View {
    @State private var showSignInWebView = false

    @State private var selectedIdentityProvider: SPIDIdentityProvider? = nil

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
                .onChange(of: selectedIdentityProvider) { _ in
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
                    try? SPIDSignInWebView(idp: selectedIdentityProvider) { accessToken in
                        showSignInWebView = false

                        print(accessToken)
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