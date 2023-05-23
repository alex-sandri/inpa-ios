//
//  Concorsi.swift
//  InPA
//
//  Created by Alex Sandri on 21/05/23.
//

import Foundation

struct Concorsi: Codable {
    var content: [Concorso]
    let pageable: Pageable
    let last: Bool
    let totalPages: Int
    let totalElements: Int

    static func list(query: String, filters: Filters, page: Int = 0, pageSize: Int = 4) async throws -> Concorsi {
        let url = "https://portale.inpa.gov.it/concorsi-smart/api/concorso-public-area/search-better?page=\(page)&size=\(pageSize)"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'00:00:00+00:00"

        var fromDateString: String? = nil
        var toDateString: String? = nil

        if let fromDate = filters.fromDate {
            fromDateString = dateFormatter.string(from: fromDate)
        }

        if let toDate = filters.toDate {
            toDateString = dateFormatter.string(from: toDate)
        }

        let body: [String: Any?] = [
            "text": query,
            "status": filters.status?.apiValues() ?? Status.all.apiValues(),
            "regioneId": filters.geographicArea?.id,
            "categoriaId": filters.category?.id,
            "settoreId": filters.sector?.id,
            "dateFrom": fromDateString,
            "dateTo": toDateString,
            "livelliAnzianitaIds": nil,
            "tipoImpiegoId": nil,
            "salaryMin": filters.minSalary,
            "salaryMax": filters.maxSalary,
        ]

        let parser = JsonParser<Concorsi>()

        return try await parser.load("POST", url, body: body)
    }
}
