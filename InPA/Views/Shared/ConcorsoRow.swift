//
//  ConcorsoRow.swift
//  InPA
//
//  Created by Alex Sandri on 22/05/23.
//

import SwiftUI

struct ConcorsoRow: View {
    private var concorso: Concorso

    init(_ concorso: Concorso) {
        self.concorso = concorso
    }

    var body: some View {
        let statusForegroundColor: Color = concorso.calculatedStatus == Status.open ? .white : .white
        let statusBackgroundColor = concorso.calculatedStatus == Status.open ? Color("AccentColor") : .red

        VStack(alignment: .leading) {
            Text(concorso.calculatedStatus.displayName().uppercased())
                .font(.system(size: 10))
                .foregroundColor(statusForegroundColor)
                .padding(4)
                .background(statusBackgroundColor)
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(statusBackgroundColor, lineWidth: 1)
                )
            Text(concorso.titolo)
                .padding(.bottom, 2)
            VStack(alignment: .leading) {
                Text("**Area geografica:** \(concorso.sediFormatted)")
                Text("**Valutazione:** \(concorso.tipoProcedura.displayName())")
                Text("**Data apertura candidature:** \(concorso.fromDateFormatted)")
                Text("**Data chiusura candidature:** \(concorso.toDateFormatted)")
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
    }
}
