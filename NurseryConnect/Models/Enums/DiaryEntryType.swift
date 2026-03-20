//
//  DiaryEntryType.swift
//  NurseryConnect
//
//  Purpose: Defines persisted diary entry categories for daily care logs.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import Foundation

// MARK: - DiaryEntryType

/// Categories of diary entries recorded for a child during the day.
enum DiaryEntryType: String, CaseIterable, Codable, Sendable {
    case activity
    case sleep
    case meal
    case nappy
    case wellbeing
    case milestone
    case departure
    case arrival
}
