//
//  BodyMapMarker.swift
//  NurseryConnect
//
//  Purpose: SwiftData model for a single tap marker on the incident body map.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import Foundation
import SwiftData

// MARK: - BodyMapMarker

/// Normalised coordinates for an injury or observation point on a silhouette.
@Model
final class BodyMapMarker {
    /// Marker identifier.
    var id: UUID
    /// Horizontal position in unit space 0...1.
    var xPosition: Double
    /// Vertical position in unit space 0...1.
    var yPosition: Double
    /// `BodySide` raw value.
    var sideRaw: String
    /// Clinician or keyworker note for this point.
    var note: String
    /// Parent incident when persisted.
    var incidentReport: IncidentReport?

    /// Creates a body map marker.
    /// - Parameters:
    ///   - id: UUID.
    ///   - xPosition: Normalised x.
    ///   - yPosition: Normalised y.
    ///   - sideRaw: Side string.
    ///   - note: Annotation.
    ///   - incidentReport: Optional parent link.
    init(
        id: UUID,
        xPosition: Double,
        yPosition: Double,
        sideRaw: String,
        note: String,
        incidentReport: IncidentReport? = nil
    ) {
        self.id = id
        self.xPosition = xPosition
        self.yPosition = yPosition
        self.sideRaw = sideRaw
        self.note = note
        self.incidentReport = incidentReport
    }
}
