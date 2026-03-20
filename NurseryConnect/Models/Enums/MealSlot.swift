//
//  MealSlot.swift
//  NurseryConnect
//
//  Purpose: Meal or snack slot within the nursery day.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import Foundation

// MARK: - MealSlot

/// Named meal periods used when logging food intake.
enum MealSlot: String, CaseIterable, Codable, Sendable {
    case breakfast
    case morningSnack
    case lunch
    case afternoonSnack
}
