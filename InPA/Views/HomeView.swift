//
//  ContentView.swift
//  InPA
//
//  Created by Alex Sandri on 20/05/23.
//

import SwiftUI

struct HomeView: View {
    @State private var query: String = ""
    @State private var filters: Filters = Filters()

    @State private var concorsi: Concorsi? = nil

    @State private var searchTask: Task<(), Error>?

    @State private var showFilters = false

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
        NavigationStack {
            // TODO: Load more results if not last page
            // TODO: Show message if empty results
            List {
                if let concorsi {
                    Text("Trovati **\(concorsi.totalElements)** risultati")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    ForEach(concorsi.content) { concorso in
                        NavigationLink {
                            ConcorsoDetailsView(id: concorso.id)
                        } label: {
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
                    // TODO: Fix this only showing up the first time
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
            }
            .listStyle(.grouped)
            .scrollContentBackground(.hidden)
            .refreshable {
                await getConcorsi()
            }
            .searchable(
                text: $query,
                placement: .navigationBarDrawer(displayMode: .always)
            )
            .onChange(of: query) { query in
                searchTask?.cancel()

                searchTask = Task {
                    try await Task.sleep(for: .seconds(0.5))

                    await getConcorsi(reset: true)
                }
            }
            .onChange(of: filters) { filters in
                searchTask?.cancel()

                searchTask = Task {
                    await getConcorsi(reset: true)
                }
            }
            .navigationTitle("InPA")
            .toolbar {
                Button {
                    showFilters.toggle()
                } label: {
                    Label(
                        "Filtra",
                        systemImage: "line.3.horizontal.decrease.circle"
                    )
                }
                .sheet(isPresented: $showFilters) {
                    HomeFiltersView(filters: $filters)
                }
            }
            .task {
               await getConcorsi()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
