//
//  JsonParser.swift
//  InPA
//
//  Created by Alex Sandri on 21/05/23.
//

import Foundation
import os

enum JsonParserError: Error {
    case invalidUrl
    case missingAuth
}

struct JsonParser<T: Decodable> {
    private var logger = Logger.initFor(JsonParser.self)

    func load(
        _ httpMethod: String,
        _ urlString: String,
        body: [String: Any?]? = nil,
        /// Whether this request should be authenticated
        auth: Bool = false
    ) async throws -> T {
        logger.info("\(httpMethod) \(urlString)")

        guard let url = URL(string: urlString) else {
            throw JsonParserError.invalidUrl
        }

        var request = URLRequest(url: url)

        request.httpMethod = httpMethod

        if httpMethod != "GET" {
            request.httpBody = try JSONSerialization.data(withJSONObject: body ?? [] as [Any])
        }

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if auth {
            let accessToken = await AuthStore.shared.accessToken

            guard let accessToken else {
                throw JsonParserError.missingAuth
            }

            request.setValue("access_token=\(accessToken)", forHTTPHeaderField: "Cookie")
        }

        let (data, _) = try await URLSession.shared.data(for: request)

        return try parse(data)
    }

    func parse(_ data: Data) throws -> T {
        let decoder = JSONDecoder()

        return try decoder.decode(T.self, from: data)
    }
}
