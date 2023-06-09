//
//  SavedForLaterStore.swift
//  InPA
//
//  Created by Alex Sandri on 23/05/23.
//

import Foundation
import SwiftData

@MainActor
@Observable
class SavedForLaterStore {
    static let shared = SavedForLaterStore()

    private init() {}

    var objects: [ConcorsoDetails] = []

    private static func fileURL() throws -> URL {
        try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        .appendingPathComponent("saved-for-later.data")
    }

    func load() async throws {
        let task = Task<[ConcorsoDetails], Error> {
            let fileURL = try Self.fileURL()

            guard let data = try? Data(contentsOf: fileURL) else {
                return []
            }

            let objects = try JSONDecoder().decode([ConcorsoDetails].self, from: data)

            return objects
        }

        let objects = try await task.value

        self.objects = objects
    }

    func contains(id: String) -> Bool {
        return objects.contains(where: { $0.id == id })
    }

    func add(_ object: ConcorsoDetails) async throws {
        if contains(id: object.id) {
            return
        }

        objects.append(object)

        try await save()
    }

    func update(id: String, with: ConcorsoDetails) async throws {
        assert(id == with.id)

        if !contains(id: id) {
            return
        }

        let indexToReplace = objects.firstIndex(where: { $0.id == id })

        if let indexToReplace {
            objects[indexToReplace] = with

            try await save()
        }
    }

    func remove(id: String) async throws {
        if !contains(id: id) {
            return
        }

        objects.removeAll(where: { $0.id == id })

        try await save()
    }

    private func save() async throws {
        let task = Task {
            let data = try JSONEncoder().encode(objects)
            let outfile = try Self.fileURL()

            try data.write(to: outfile)
        }

        try await task.value
    }
}
