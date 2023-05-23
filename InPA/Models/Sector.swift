//
//  Sector.swift
//  InPA
//
//  Created by Alex Sandri on 21/05/23.
//

struct Sector: Codable, Equatable, Identifiable {
    let id: String
    let name: String
    let description: String?
    let parentId: String
    let features: SectorFeatures

    static func list() async throws -> [Sector] {
        let url = "https://portale.inpa.gov.it/concorsi-smart/api/concorso/get-settori"

        let parser = JsonParser<[Sector]>()

        return try await parser.load("GET", url)
    }

    static func == (lhs: Sector, rhs: Sector) -> Bool {
        return lhs.id == rhs.id
    }
}
