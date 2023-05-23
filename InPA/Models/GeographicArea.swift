//
//  GeographicArea.swift
//  InPA
//
//  Created by Alex Sandri on 21/05/23.
//

struct GeographicArea: Codable, Equatable, Identifiable {
    let id: String
    let denominazione: String
    let latitudine: Double
    let longitudine: Double

    static func list() async throws -> [GeographicArea] {
        let url = "https://portale.inpa.gov.it/concorsi-smart/api/indirizzo/regioni/find-all"

        let parser = JsonParser<[GeographicArea]>()

        return try await parser.load("GET", url)
    }

    static func == (lhs: GeographicArea, rhs: GeographicArea) -> Bool {
        return lhs.id == rhs.id
    }
}
