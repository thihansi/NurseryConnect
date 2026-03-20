//
//  MealConsumption.swift
//  NurseryConnect
//
//  Purpose: How much of a meal a child consumed.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import Foundation

// MARK: - MealConsumption

/// Portion consumed during a meal log.
enum MealConsumption: String, CaseIterable, Codable, Sendable {
    case all
    case most
    case half
    case little
    case none
    case refused
}
