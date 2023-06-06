//
//  CandidaturaType.swift
//  InPA
//
//  Created by Alex Sandri on 04/06/23.
//

enum CandidaturaType: CaseIterable, Identifiable {
    var id: Self {
        return self
    }

    case sent
    case draft

    var displayName: String {
        switch self {
        case .sent:
            return "Inviate"
        case .draft:
            return "In compilazione"
        }
    }

    var systemImage: String {
        switch self {
        case .sent: return "paperplane"
        case .draft: return "pencil"
        }
    }
}
