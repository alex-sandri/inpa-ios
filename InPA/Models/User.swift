//
//  User.swift
//  InPA
//
//  Created by Alex Sandri on 03/06/23.
//

struct User: Codable {
    let id: Int

    let firstName: String
    let lastName: String

    let email: String

    static func get(accessToken: String) async throws -> User {
        let url = "https://portale.inpa.gov.it/uaa/api/profile"

        let parser = JsonParser<User>()

        return try await parser.load("GET", url, auth: true)
    }
}
