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

    func getDetails() async {
        let result = try? await ConcorsoDetails.get(id: id)

        details = result
    }

    var body: some View {
        NavigationStack {
            if let details {
                let sendApplicationUrl = details.linkReindirizzamento ?? "https://portale.inpa.gov.it/ui/public-area/login?returnUrl=%2Fpublic-area%2Fconcoursedetail%2F\(id)"

                List {
                    Text(details.descrizioneBreve)
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

                    Section("Bando/Avviso e Allegati") {
                        if details.allegati.isEmpty {
                            Text("Non ci sono allegati da mostrare")
                        }

                        ForEach(details.allegati) { attachment in
                            if let url = attachment.url {
                                Link(attachment.label, destination: url)
                            }
                        }
                    }
                }
                .toolbar {
                    ToolbarItem {
                        Button {
                            let url = "https://www.inpa.gov.it/bandi-e-avvisi/dettaglio-bando-avviso/?concorso_id=\(id)"

                            if let url = URL(string: url) {
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            Label(
                                "Apri nel browser",
                                systemImage: "arrow.up.forward.app"
                            )
                        }
                    }

                    if details.calculatedStatus == Status.open, let url = URL(string: sendApplicationUrl) {
                        ToolbarItem(placement: .bottomBar) {
                            Button {
                                UIApplication.shared.open(url)
                            } label: {
                                Text("Invia la tua candidatura")
                                    .frame(maxWidth: .infinity)
                            }
                            .controlSize(.large)
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }
                .navigationTitle("Dettagli")
            } else {
                ProgressView()
            }
        }
        .task {
            await getDetails()
        }
    }
}
