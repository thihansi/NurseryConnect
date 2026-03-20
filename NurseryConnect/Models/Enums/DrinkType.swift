//
//  DrinkType.swift
//  NurseryConnect
//
//  Purpose: Drink categories paired with fluid intake logging.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import Foundation

// MARK: - DrinkType

/// Types of drinks offered during meal or hydration logs.
enum DrinkType: String, CaseIterable, Codable, Sendable {
    case water
    case milk
    case juice
    case oatMilk
    case other
}
