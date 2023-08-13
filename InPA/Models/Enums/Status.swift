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
    case visible = "VISIBLE"

    func displayName() -> String {
        switch self {
        case .all:
            return "Tutti"
        case .closed:
            return "Chiuso"
        case .open:
            return "Aperto"
        case .visible:
            return "In apertura"
        }
    }

    func apiValues() -> [String] {
        switch self {
        case .all:
            return ["CLOSED", "OPEN"]
        default:
            return [self.rawValue]
        }
    }
}
