//
//  Category.swift
//  InPA
//
//  Created by Alex Sandri on 21/05/23.
//

struct Category: Codable, Equatable, Identifiable {
    let id: String
    let name: String
    let description: String?
    let parentId: String
    let features: CategoryFeatures

    static func list() async throws -> [Category] {
        let url = "https://portale.inpa.gov.it/concorsi-smart/api/concorso/get-categorie"

        let parser = JsonParser<[Category]>()

        return try await parser.load("GET", url)
    }

    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.id == rhs.id
    }
}
