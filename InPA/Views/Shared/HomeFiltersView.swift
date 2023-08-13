//
//  HomeFilters.swift
//  InPA
//
//  Created by Alex Sandri on 22/05/23.
//

import SwiftUI

struct HomeFiltersView: View {
    let filters: Filters
    let didFilter: (Filters) -> Void

    @State private var selectedCategory = "0"
    @State private var categories: [Category] = []

    @State private var selectedGeographicArea = "0"
    @State private var geographicAreas: [GeographicArea] = []

    @State private var selectedStatus = Status.all

    @State private var selectedSector = "0"
    @State private var sectors: [Sector] = []

    @State private var fromDate: Date = Date.now
    @State private var didSetFromDate = false

    @State private var toDate: Date = Date.now
    @State private var didSetToDate = false

    @State private var minSalary = ""
    @State private var maxSalary = ""

    func setCategories(_ categories: [Category], selected: String?) {
        self.categories = categories
        selectedCategory = selected ?? "0"
    }

    func setGeographicAreas(_ geographicAreas: [GeographicArea], selected: String?) {
        self.geographicAreas = geographicAreas
        selectedGeographicArea = selected ?? "0"
    }

    func setSectors(_ sectors: [Sector], selected: String?) {
        self.sectors = sectors
        selectedSector = selected ?? "0"
    }

    func initialize() async {
        if let minSalary = self.filters.minSalary {
            self.minSalary = "\(minSalary)"
        }

        if let maxSalary = self.filters.maxSalary{
            self.maxSalary = "\(maxSalary)"
        }

        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                let categories = try? await Category.list()

                if let categories {
                    setCategories(categories, selected: self.filters.category?.id)
                }
            }

            group.addTask {
                let geographicAreas = try? await GeographicArea.list()

                if let geographicAreas {
                    setGeographicAreas(geographicAreas, selected: self.filters.geographicArea?.id)
                }
            }

            group.addTask {
                let sectors = try? await Sector.list()

                if let sectors {
                    setSectors(sectors, selected: self.filters.sector?.id)
                }
            }
        }
    }

    func dismissAndUpdate() {
        var newFilters = Filters()

        newFilters.category = categories.first(where: { $0.id == selectedCategory })
        newFilters.geographicArea = geographicAreas.first(where: { $0.id == selectedGeographicArea })
        newFilters.status = selectedStatus
        newFilters.sector = sectors.first(where: { $0.id == selectedSector })

        if didSetFromDate {
            newFilters.fromDate = fromDate
        }

        if didSetToDate {
            newFilters.toDate = toDate
        }

        if let minSalary = Int(minSalary) {
            newFilters.minSalary = minSalary
        } else if minSalary.isEmpty {
            newFilters.minSalary = nil
        }

        if let maxSalary = Int(maxSalary) {
            newFilters.maxSalary = maxSalary
        } else if maxSalary.isEmpty {
            newFilters.maxSalary = nil
        }

        didFilter(newFilters)
    }

    var body: some View {
        Form {
            Text("Filtri")
                .font(Fonts.default.largeTitle)
                .fontWeight(.bold)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())

            Section {
                Picker(
                    selection: $selectedCategory,
                    label: Text("Categoria")
                ) {
                    Text("Tutte").tag("0")
                    ForEach(categories) { category in
                        Text(category.name).tag(category.id)
                    }
                }
                Picker(
                    selection: $selectedGeographicArea,
                    label: Text("Area geografica")
                ) {
                    Text("Tutte").tag("0")
                    ForEach(geographicAreas) { geographicArea in
                        Text(geographicArea.denominazione).tag(geographicArea.id)
                    }
                }
                Picker(
                    selection: $selectedStatus,
                    label: Text("Stato")
                ) {
                    ForEach(Status.allCases) { status in
                        Text(status.displayName()).tag(status)
                    }
                }
                .onAppear {
                    // I'm using .onAppear as otherwise this wouldn't work inside init() for some reason
                    selectedStatus = filters.status ?? Status.all
                }
                Picker(
                    selection: $selectedSector,
                    label: Text("Settore")
                ) {
                    Text("Tutti").tag("0")
                    ForEach(sectors) { sector in
                        Text(sector.name).tag(sector.id)
                    }
                }
            }

            Section {
                if didSetFromDate {
                    DatePicker(
                        selection: $fromDate,
                        in: Date.distantPast...toDate,
                        displayedComponents: [.date],
                        label: { Text("Dal") }
                    )
                    .onAppear {
                        fromDate = filters.fromDate ?? Date.now
                    }
                } else {
                    LabeledContent("Dal") {
                        Button("Scegli") {
                            didSetFromDate = true
                        }
                    }
                }

                if didSetToDate {
                    DatePicker(
                        selection: $toDate,
                        in: fromDate...Date.now,
                        displayedComponents: [.date],
                        label: { Text("Al") }
                    )
                    .onAppear {
                        toDate = filters.toDate ?? Date.now
                    }
                } else {
                    LabeledContent("Al") {
                        Button("Scegli") {
                            didSetToDate = true
                        }
                    }
                }
            } header: {
                Text("Periodo di pubblicazione")
                    .font(Fonts.default.subheadline)
            }
            .onAppear {
                didSetFromDate = filters.fromDate != nil
                didSetToDate = filters.toDate != nil
            }
            Section {
                LabeledContent("Da") {
                    TextField("€", text: $minSalary)
                        #if os(iOS)
                        .keyboardType(.numberPad)
                        #endif
                        .onChange(of: minSalary) { _, newValue in
                            minSalary = newValue.filter { $0.isNumber }
                        }
                }
                LabeledContent("A") {
                    TextField("€", text: $maxSalary)
                        #if os(iOS)
                        .keyboardType(.numberPad)
                        #endif
                        .onChange(of: maxSalary) { _, newValue in
                            maxSalary = newValue.filter { $0.isNumber }
                        }
                }
            } header: {
                Text("Salario")
                    .font(Fonts.default.subheadline)
            }
            Button {
                dismissAndUpdate()
            } label: {
                Text("Conferma")
                    .frame(maxWidth: .infinity)
            }
            .controlSize(.large)
            .buttonStyle(.borderedProminent)
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
            Button {
                didFilter(Filters())
            } label: {
                Text("Ripristina")
                    .frame(maxWidth: .infinity)
            }
            .controlSize(.large)
            .buttonStyle(.borderedProminent)
            .tint(Color.clear)
            .foregroundColor(.primary)
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
            .padding(.top, 10)
        }
        #if os(macOS)
        .padding()
        #endif
        .task {
            await initialize()
        }
    }
}

#Preview {
    let filters = Filters()

    return HomeFiltersView(filters: filters) { filters in
        print(filters)
    }
        .font(Fonts.default.body)
        .task { await InPAApp.initialize() }
}
