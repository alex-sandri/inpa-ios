//
//  ConcorsoView.swift
//  InPA
//
//  Created by Alex Sandri on 23/05/23.
//

import SwiftUI

struct ConcorsoDetailsView: View {
    let id: String

    @State private var details: ConcorsoDetails? = nil

    @State private var savedForLaterStore = SavedForLaterStore.shared

    func getDetails() async {
        let result = try? await ConcorsoDetails.get(id: id)

        details = result
    }

    var body: some View {
        NavigationStack {
            if let details {
                List {
                    Section {
                        Text(details.descrizioneBreve)
                    } header: {
                        Text("Descrizione")
                            .font(Fonts.default.subheadline)
                    }

                    Section {
                        LabeledContent("Area geografica", value: details.expandedLocationFormatted)
                        LabeledContent("Valutazione", value: details.tipoProcedura.displayName())
                        LabeledContent("Stato", value: details.calculatedStatus.displayName())
                        LabeledContent("Data apertura candidature", value: details.fromDateFormatted)
                        LabeledContent("Data chiusura invio candidature", value: details.toDateFormatted)

                        if let numPosti = details.numPosti {
                            LabeledContent("Numero di posti", value: "\(numPosti)")
                        }

                        LabeledContent("Ente di riferimento", value: details.company.name)

                        if let urlString = details.linkSitoPA, let url = URL(string: urlString) {
                            Link("Link al sito della PA", destination: url)
                        }
                    }

                    if details.calculatedStatus == Status.open, let url = details.applicationURL {
                        Link(destination: url) {
                            Text("Invia la tua candidatura")
                                .frame(maxWidth: .infinity)
                        }
                        .controlSize(.large)
                        .buttonStyle(.borderedProminent)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
                    }

                    Section {
                        if details.allegati.isEmpty {
                            Text("Non ci sono allegati da mostrare")
                        }

                        ForEach(details.allegati) { attachment in
                            if let url = attachment.url {
                                Link(attachment.label, destination: url)
                            }
                        }
                    } header: {
                        Text("Bando/Avviso e Allegati")
                            .font(Fonts.default.subheadline)
                    }
                }
                .toolbar {
                    ToolbarItem {
                        Button {
                            Task {
                                try await savedForLaterStore.contains(id: details.id)
                                ? savedForLaterStore.remove(id: details.id)
                                : savedForLaterStore.add(details)
                            }
                        } label: {
                            Label(
                                savedForLaterStore.contains(id: details.id)
                                ? "Rimuovi"
                                : "Salva per dopo",
                                systemImage:  savedForLaterStore.contains(id: details.id)
                                ? "bookmark.fill"
                                : "bookmark"
                            )
                        }
                    }

                    if let url = details.url {
                        ToolbarItem {
                            Link(destination: url) {
                                Label(
                                    "Apri nel browser",
                                    systemImage: "arrow.up.forward.app"
                                )
                            }
                        }
                    }
                }
                .navigationTitle("Dettagli")
            } else {
                ProgressView()
            }
        }
        .refreshable {
            await getDetails()
        }
        .task {
            await getDetails()
        }
    }
}
