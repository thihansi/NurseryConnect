//
//  String+Extensions.swift
//  NurseryConnect
//
//  Purpose: String helpers for initials and allergy keyword checks.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import Foundation

// MARK: - Initials

extension String {
    /// Up to two initials derived from whitespace-separated name parts.
    /// - Returns: Uppercased initials or a single character fallback.
    func ncInitials(maxCount: Int = 2) -> String {
        let parts = split(separator: " ").map(String.init).filter { !$0.isEmpty }
        guard !parts.isEmpty else {
            return ""
        }
        let letters = parts.prefix(maxCount).compactMap { part -> String? in
            guard let first = part.first else { return nil }
            return String(first).uppercased()
        }
        return letters.joined()
    }

    /// Case-insensitive check whether any allergy term appears in this string.
    /// - Parameter allergies: Allergen phrases to search for.
    /// - Returns: True when a substring match is found.
    func ncContainsAnyAllergyKeyword(allergies: [String]) -> Bool {
        let haystack = lowercased()
        for allergy in allergies {
            let needle = allergy.lowercased()
            if needle.isEmpty { continue }
            if haystack.contains(needle) { return true }
        }
        return false
    }
}
