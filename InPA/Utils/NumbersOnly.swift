//
//  NumbersOnly.swift
//  InPA
//
//  Created by Alex Sandri on 21/05/23.
//

import Foundation

class NumbersOnly: ObservableObject {
    @Published var value = "" {
        didSet {
            let filtered = value.filter { $0.isNumber }

            if value != filtered {
                value = filtered
            }
        }
    }
}
