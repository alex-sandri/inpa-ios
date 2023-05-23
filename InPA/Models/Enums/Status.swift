//
//  Status.swift
//  InPA
//
//  Created by Alex Sandri on 21/05/23.
//

enum Status: String, CaseIterable, Codable, Identifiable {
    var id: Self {
        return self
    }

    case all = "ALL"
    case closed = "CLOSED"
    case open = "OPEN"

    func displayName() -> String {
        switch self {
        case .all:
            return "Tutti"
        case .closed:
            return "Chiuso"
        case .open:
            return "Aperto"
        }
    }

    func apiValues() -> [String] {
        switch self {
        case .all:
            return ["CLOSED", "OPEN"]
        case .closed:
            return ["CLOSED"]
        case .open:
            return ["OPEN"]
        }
    }
}
