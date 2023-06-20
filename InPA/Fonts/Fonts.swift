//
//  Fonts.swift
//  inPA
//
//  Created by Alex Sandri on 18/06/23.
//

import SwiftUI

/// Sizes source: https://www.iosfontsizes.com
struct Fonts {
    static let `default` = Fonts.TitilliumWeb.self

    struct TitilliumWeb {
        private static let familyName = "Titillium Web"

        static let largeTitle = Self.with(size: 34)
        static let title = Self.with(size: 28)
        static let title2 = Self.with(size: 22)
        static let title3 = Self.with(size: 20)
        static let headline = Self.with(size: 17)
        static let subheadline = Self.with(size: 15)
        static let body = Self.with(size: 17)
        static let callout = Self.with(size: 16)
        static let caption = Self.with(size: 12)
        static let caption2 = Self.with(size: 11)
        static let footnote = Self.with(size: 13)

        static func with(size: CGFloat) -> Font {
            Font.custom(familyName, size: size)
        }
    }
}
