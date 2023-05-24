//
//  SavedForLaterView.swift
//  InPA
//
//  Created by Alex Sandri on 23/05/23.
//

import SwiftUI

struct SavedForLaterView: View {
    @StateObject private var savedForLaterStore = SavedForLaterStore.shared

    var body: some View {
        NavigationStack {
            VStack {
                if $savedForLaterStore.objects.count > 0 {
                    List {
                        ForEach($savedForLaterStore.objects) { savedForLater in
                            NavigationLink {
                                ConcorsoDetailsView(id: savedForLater.id)
                            } label: {
                                Text(savedForLater.wrappedValue.titolo)
                            }
                        }
                    }
                    .listStyle(.grouped)
                    .scrollContentBackground(.hidden)
                } else {
                    Text("Non hai ancora salvato niente per dopo")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Salvati per dopo")
        }
    }
}

struct SavedForLaterView_Previews: PreviewProvider {
    static var previews: some View {
        SavedForLaterView()
            .task {
                do {
                    try await SavedForLaterStore.shared.load()
                } catch {
                    fatalError(error.localizedDescription)
                }
            }
    }
}
