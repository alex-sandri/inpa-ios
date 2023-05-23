//
//  HomeFilters.swift
//  InPA
//
//  Created by Alex Sandri on 22/05/23.
//

import SwiftUI

struct HomeFiltersView: View {
    @Binding var filters: Filters

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

    @ObservedObject var minSalary = NumbersOnly()
    @ObservedObject var maxSalary = NumbersOnly()

    @Environment(\.dismiss) private var dismiss

    init(filters: Binding<Filters>) {
        _filters = filters

        if let minSalary = self.filters.minSalary {
            self.minSalary.value = "\(minSalary)"
        }

        if let maxSalary = self.filters.maxSalary{
            self.maxSalary.value = "\(maxSalary)"
        }
    }

    func initialize() async {
        // TODO: Load all of these together

        let categories = try? await Category.list()

        if let categories {
            self.categories = categories
            selectedCategory = self.filters.category?.id ?? "0"
        }

        let geographicAreas = try? await GeographicArea.list()

        if let geographicAreas {
            self.geographicAreas = geographicAreas
            selectedGeographicArea = self.filters.geographicArea?.id ?? "0"
        }

        let sectors = try? await Sector.list()

        if let sectors {
            self.sectors = sectors
            selectedSector = self.filters.sector?.id ?? "0"
        }
    }

    func dismissAndUpdate() {
        filters.category = categories.first(where: { $0.id == selectedCategory })
        filters.geographicArea = geographicAreas.first(where: { $0.id == selectedGeographicArea })
        filters.status = selectedStatus
        filters.sector = sectors.first(where: { $0.id == selectedSector })

        if didSetFromDate {
            filters.fromDate = fromDate
        }

        if didSetToDate {
            filters.toDate = toDate
        }

        if let minSalary = Int(minSalary.value) {
            filters.minSalary = minSalary
        } else if minSalary.value.isEmpty {
            filters.minSalary = nil
        }

        if let maxSalary = Int(maxSalary.value) {
            filters.maxSalary = maxSalary
        } else if maxSalary.value.isEmpty {
            filters.maxSalary = nil
        }

        dismiss()
    }

    var body: some View {
        Form {
            Section {
                Text("Filtri")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
            }
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
            Section(header: Text("Periodo di pubblicazione")) {
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
            }
            .onAppear {
                didSetFromDate = filters.fromDate != nil
                didSetToDate = filters.toDate != nil
            }
            Section(header: Text("Salario")) {
                LabeledContent("Da") {
                    TextField("€", text: $minSalary.value)
                        .keyboardType(.numberPad)
                }
                LabeledContent("A") {
                    TextField("€", text: $maxSalary.value)
                        .keyboardType(.numberPad)
                }
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
                filters = Filters()
                dismiss()
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
        .task {
            await initialize()
        }
    }
}
