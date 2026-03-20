//
//  IncidentCategory.swift
//  NurseryConnect
//
//  Purpose: Incident taxonomy for safeguarding and first aid workflows.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import Foundation

// MARK: - IncidentCategory

/// High-level incident classification for reporting and review.
enum IncidentCategory: String, CaseIterable, Codable, Sendable {
    case accidentMinor
    case accidentFirstAid
    case safeguardingConcern
    case nearMiss
    case allergicReaction
    case medicalIncident
}
