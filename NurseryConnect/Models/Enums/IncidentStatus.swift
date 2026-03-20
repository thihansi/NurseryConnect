//
//  IncidentStatus.swift
//  NurseryConnect
//
//  Purpose: Workflow states for incident reports from draft to acknowledgement.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import Foundation

// MARK: - IncidentStatus

/// Lifecycle status of an incident report.
enum IncidentStatus: String, CaseIterable, Codable, Sendable {
    case draft
    case submittedForReview
    case parentNotified
    case acknowledged
}
