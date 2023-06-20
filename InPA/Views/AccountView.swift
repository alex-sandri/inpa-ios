//
//  AccountView.swift
//  InPA
//
//  Created by Alex Sandri on 03/06/23.
//

import SwiftUI

struct AccountView: View {
    @State private var authStore = AuthStore.shared

    var body: some View {
        NavigationStack {
            List {
                if let user = authStore.user {
                    Section {
                        LabeledContent("Nome", value: user.firstName)
                        LabeledContent("Cognome", value: user.lastName)
                        LabeledContent("Email", value: user.email)
                    } header: {
                        Text("Dettagli")
                            .font(Fonts.default.subheadline)
                    }

                    Section {
                        ForEach(CandidaturaType.allCases) { type in
                            NavigationLink {
                                CandidatureView(type: type)
                            } label: {
                                Label(type.displayName, systemImage: type.systemImage)
                            }
                        }
                    } header: {
                        Text("Candidature")
                            .font(Fonts.default.subheadline)
                    }
                }
            }
            .navigationTitle("Account")
            .toolbar {
                Button {
                    Task {
                        await authStore.signOut()
                    }
                } label: {
                    Label(
                        "Esci",
                        systemImage: "rectangle.portrait.and.arrow.forward"
                    )
                }
            }
        }
    }
}

#Preview {
    AccountView()
        .task { await InPAApp.initialize() }
}
