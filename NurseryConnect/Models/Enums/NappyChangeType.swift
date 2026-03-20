//
//  NappyChangeType.swift
//  NurseryConnect
//
//  Purpose: Nappy check outcomes for care logs.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import Foundation

// MARK: - NappyChangeType

/// Result of a nappy check or change.
enum NappyChangeType: String, CaseIterable, Codable, Sendable {
    case wet
    case dirty
    case both
    case none
}
