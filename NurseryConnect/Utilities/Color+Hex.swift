//
//  Color+Hex.swift
//  NurseryConnect
//
//  Purpose: Builds SwiftUI colours from stored hex strings for avatars.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import SwiftUI

// MARK: - Hex parsing

extension Color {
    /// Parses `#RRGGBB` or `RRGGBB` into a `Color`, falling back to teal.
    /// - Parameter hex: Optional hex string from persistence.
    /// - Returns: A displayable colour.
    static func ncFromProfileHex(_ hex: String?) -> Color {
        guard var text = hex?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else {
            return .primaryTeal
        }
        if text.hasPrefix("#") {
            text.removeFirst()
        }
        guard text.count == 6, let value = UInt32(text, radix: 16) else {
            return .primaryTeal
        }
        let red = Double((value >> 16) & 0xFF) / 255
        let green = Double((value >> 8) & 0xFF) / 255
        let blue = Double(value & 0xFF) / 255
        return Color(red: red, green: green, blue: blue)
    }
}
