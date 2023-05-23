//
//  Attachment.swift
//  InPA
//
//  Created by Alex Sandri on 23/05/23.
//

import Foundation

struct Attachment: Codable, Identifiable {
    let id: String
    let mediaId: String
    let label: String

    var url: URL? {
        return URL(string: "https://portale.inpa.gov.it/api/media/\(mediaId)")
    }
}
