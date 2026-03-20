//
//  BodyMapMarkerDraft.swift
//  NurseryConnect
//
//  Purpose: Transient marker tapped on the body map before saving an incident.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import Foundation

// MARK: - BodyMapMarkerDraft

/// Normalised tap with a display index for numbering.
struct BodyMapMarkerDraft: Identifiable, Equatable {
    /// Stable id for SwiftUI lists.
    var id: UUID
    /// Horizontal normalised coordinate.
    var xPosition: Double
    /// Vertical normalised coordinate.
    var yPosition: Double
    /// Active silhouette side.
    var side: BodySide
    /// Free-text note beside the marker.
    var note: String
    /// One-based label shown on the silhouette.
    var displayIndex: Int
}
