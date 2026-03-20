//
//  MoodRating.swift
//  NurseryConnect
//
//  Purpose: Mood scale for wellbeing diary entries.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import Foundation

// MARK: - MoodRating

/// Subjective mood observations for wellbeing logging.
enum MoodRating: String, CaseIterable, Codable, Sendable {
    case happy
    case settled
    case unsettled
    case upset
    case unwell
}
