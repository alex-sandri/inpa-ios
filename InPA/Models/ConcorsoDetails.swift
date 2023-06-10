//
//  ConcorsoDetails.swift
//  InPA
//
//  Created by Alex Sandri on 23/05/23.
//

import Foundation

struct ConcorsoDetails: Codable, Identifiable {
    let id: String
    let codice: String
    let titolo: String
    let descrizione: String
    let descrizioneBreve: String
    let calculatedStatus: Status
    let dataVisibilita: String
    let dataPubblicazione: String
    let dataScadenza: String
    let tipoProcedura: SelectionType
    let numPosti: Int?
    let company: Company
    let allegati: [Attachment]
    let linkSitoPA: String?
    let linkReindirizzamento: String?
    let expandedLocation: String
    
    var url: URL? {
        URL(string: "https://www.inpa.gov.it/bandi-e-avvisi/dettaglio-bando-avviso/?concorso_id=\(id)")
    }

    var applicationURL: URL? {
        URL(string: linkReindirizzamento ?? "https://portale.inpa.gov.it/ui/public-area/login?returnUrl=%2Fpublic-area%2Fconcoursedetail%2F\(id)")
    }

    var fromDate: Date? {
        return ISO8601DateFormatter().date(from: dataPubblicazione)
    }

    var fromDateFormatted: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"

        if let fromDate {
            return dateFormatter.string(from: fromDate)
        }

        return "N/A"
    }

    var toDate: Date? {
        return ISO8601DateFormatter().date(from: dataScadenza)
    }

    var toDateFormatted: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"

        if let toDate {
            return dateFormatter.string(from: toDate)
        }

        return "N/A"
    }

    /// Returns `expandedLocation` without the trailing comma and white space characters or, if empty, returns "**Nazionale**".
    var expandedLocationFormatted: String {
        let newExpandedLocation = expandedLocation.trimmingCharacters(in: .whitespaces.union(.punctuationCharacters))

        if newExpandedLocation.isEmpty {
            return "Nazionale"
        }

        return newExpandedLocation
    }

    static func get(id: String) async throws -> ConcorsoDetails {
        let url = "https://portale.inpa.gov.it/concorsi-smart/api/concorso-public-area/\(id)"

        let parser = JsonParser<ConcorsoDetails>()

        return try await parser.load("GET", url)
    }
}
