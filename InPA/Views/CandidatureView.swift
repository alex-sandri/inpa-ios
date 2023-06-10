//
//  CandidatureView.swift
//  InPA
//
//  Created by Alex Sandri on 04/06/23.
//

import SwiftUI

struct CandidatureView: View {
    @State private var type: CandidaturaType

    init(type: CandidaturaType = CandidaturaType.sent) {
        self.type = type
    }

    var body: some View {
        NavigationStack {
            VStack {
                Picker("Tipo candidatura", selection: $type) {
                    ForEach(CandidaturaType.allCases) { type in
                        Text(type.displayName).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                List {
                    // TODO
                }
            }
            .navigationTitle("Candidature")
        }
    }
}

#Preview {
    CandidatureView()
        .task { await InPAApp.initialize() }
}
