//
//  Filters.swift
//  InPA
//
//  Created by Alex Sandri on 21/05/23.
//

import Foundation

struct Filters: Equatable {
    var category: Category?
    var geographicArea: GeographicArea?
    var status: Status?
    var sector: Sector?

    var fromDate: Date?
    var toDate: Date?

    var minSalary: Int?
    var maxSalary: Int?

    init(
        category: Category? = nil,
        geographicArea: GeographicArea? = nil,
        status: Status? = nil,
        sector: Sector? = nil,
        fromDate: Date? = nil,
        toDate: Date? = nil,
        minSalary: Int? = nil,
        maxSalary: Int? = nil
    ) {
        self.category = category
        self.geographicArea = geographicArea
        self.status = status
        self.sector = sector
        self.fromDate = fromDate
        self.toDate = toDate
        self.minSalary = minSalary
        self.maxSalary = maxSalary
    }

    static func == (lhs: Filters, rhs: Filters) -> Bool {
        return lhs.category == rhs.category
        && lhs.geographicArea == rhs.geographicArea
        && lhs.status == rhs.status
        && lhs.sector == rhs.sector
        && lhs.fromDate == rhs.fromDate
        && lhs.toDate == rhs.toDate
        && lhs.minSalary == rhs.minSalary
        && lhs.maxSalary == rhs.maxSalary
    }
}
