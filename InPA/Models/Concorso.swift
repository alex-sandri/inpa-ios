//
//  Concorso.swift
//  InPA
//
//  Created by Alex Sandri on 21/05/23.
//

import Foundation

struct Concorso: Codable, Identifiable {
    let id: String
    let codice: String
    let titolo: String
    let descrizione: String
    let descrizioneBreve: String
    let dataPubblicazione: String
    let dataScadenza: String
    let dataVisibilita: String
    let linkReindirizzamento: String?
    let tipoProcedura: SelectionType
    let statusLabel: String
    let calculatedStatus: Status
    let allegatoMediaId: String?
    let settori: [String]
    let categorie: [String]
    let sedi: [String]

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

    var sediFormatted: String {
        if sedi.isEmpty {
            return "Nazionale"
        }

        return sedi.joined(separator: ", ")
    }
}
