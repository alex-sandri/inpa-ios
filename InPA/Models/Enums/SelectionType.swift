//
//  Type.swift
//  InPA
//
//  Created by Alex Sandri on 22/05/23.
//

enum SelectionType: String, Codable {
    case exams = "ESAMI"
    case interview = "COLLOQUIO"
    case titles = "TITOLI"
    case titlesAndExams = "TITOLI_ESAMI"
    case titlesAndInterview = "TITOLI_COLLOQUIO"

    func displayName() -> String {
        switch self {
        case .exams:
            return "Esami"
        case .interview:
            return "Colloquio"
        case .titles:
            return "Titoli"
        case .titlesAndExams:
            return "Titoli ed esami"
        case .titlesAndInterview:
            return "Titoli e colloquio"
        }
    }
}
