//
//  ContentView.swift
//  InPA
//
//  Created by Alex Sandri on 20/05/23.
//

import SwiftUI

struct HomeView: View {
    @State private var progressViewId = 0

    @State private var query: String = ""
    @State private var filters: Filters = Filters()

    @State private var concorsi: Concorsi? = nil
    @State private var selectedConcorsoId: String?

    @State private var searchTask: Task<(), Error>?

    @State private var showFilters = false

    @State private var authStore = AuthStore.shared

    @Environment(\.openWindow) private var openWindow

    func getConcorsi(page: Int = 0, reset: Bool = false) async {
        if reset {
            concorsi = nil
        }

        let result = try? await Concorsi.list(
            query: query,
            filters: filters,
            page: page
        )

        if var result {
            result.content = (concorsi?.content ?? []) + result.content

            concorsi = result
        }
    }

    var body: some View {
        NavigationSplitView {
            List(selection: $selectedConcorsoId) {
                if let concorsi {
                    if concorsi.content.isEmpty {
                        Text("Non sono stati trovati risultati")
                            .font(Fonts.default.caption)
                            .foregroundColor(.secondary)
                    } else {
                        Text("Trovati **\(concorsi.totalElements)** risultati")
                            .font(Fonts.default.caption)
                            .foregroundColor(.secondary)
                    }

                    ForEach(concorsi.content) { concorso in
                        NavigationLink(value: concorso.id) {
                            ConcorsoRow(concorso)
                        }
                    }

                    if !concorsi.last {
                        Section {
                            Button("Carica altri risultati") {
                                Task {
                                    await getConcorsi(
                                        page: concorsi.pageable.pageNumber + 1
                                    )
                                }
                            }
                        }
                    }
                } else {
                    HStack {
                        Spacer()
                        ProgressView()
                            .id(progressViewId)
                            .onAppear {
                                progressViewId += 1
                            }
                        Spacer()
                    }
                }
            }
            #if os(iOS)
            .listStyle(.grouped)
            #endif
            .scrollContentBackground(.hidden)
            .refreshable {
                await getConcorsi(reset: true)
            }
            #if os(macOS)
            .searchable(
                text: $query,
                placement: .toolbar
            )
            #else
            .searchable(
                text: $query,
                placement: .navigationBarDrawer(displayMode: .always)
            )
            #endif
            .onChange(of: query) {
                searchTask?.cancel()

                searchTask = Task {
                    try await Task.sleep(for: .seconds(0.5))

                    await getConcorsi(reset: true)
                }
            }
            .onChange(of: filters) {
                searchTask?.cancel()

                searchTask = Task {
                    await getConcorsi(reset: true)
                }
            }
            .navigationTitle("inPA")
            .toolbar {
                Button {
                    showFilters.toggle()
                } label: {
                    Label(
                        "Filtra",
                        systemImage: "line.3.horizontal.decrease.circle"
                    )
                }
                #if os(macOS)
                .popover(isPresented: $showFilters) {
                    HomeFiltersView(filters: filters) { newFilters in
                        showFilters.toggle()

                        filters = newFilters
                    }
                }
                #endif

                NavigationLink {
                    SavedForLaterView()
                } label: {
                    Label(
                        "Salvati per dopo",
                        systemImage: "bookmark"
                    )
                }

                if !authStore.isSignedIn {
                    #if os(macOS)
                    Button {
                        openWindow(id: "sign-in")
                    } label: {
                        Label(
                            "Accedi",
                            systemImage: "person.crop.circle"
                        )
                    }
                    #else
                    NavigationLink {
                        SPIDSignInView()
                    } label: {
                        Label(
                            "Accedi",
                            systemImage: "person.crop.circle"
                        )
                    }
                    #endif
                }
            }
            #if os(iOS)
            .sheet(isPresented: $showFilters) {
                HomeFiltersView(filters: filters) { newFilters in
                    showFilters.toggle()

                    filters = newFilters
                }
            }
            #endif
            .task {
                // Load only if not loaded before
                if concorsi == nil {
                    await getConcorsi(reset: true)
                }
            }
        } detail: {
            if let selectedConcorsoId {
                ConcorsoDetailsView(id: selectedConcorsoId)
                    .id(selectedConcorsoId)
            } else {
                Text("Seleziona un concorso per vederne i dettagli")
            }
        }
    }
}

#Preview {
    HomeView()
        .task { await InPAApp.initialize() }
}
