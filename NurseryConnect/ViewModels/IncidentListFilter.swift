//
//  IncidentListFilter.swift
//  NurseryConnect
//
//  Purpose: Segmented control options for the incident list screen.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import Foundation

// MARK: - IncidentListFilter

/// High-level filters for incident reporting queues.
enum IncidentListFilter: String, CaseIterable, Identifiable {
    case all
    case today
    case pendingReview

    /// Conforms to `Identifiable` for pickers.
    var id: String { rawValue }

    /// User-facing segment title.
    var title: String {
        switch self {
        case .all: return "All"
        case .today: return "Today"
        case .pendingReview: return "Pending Review"
        }
    }
}
