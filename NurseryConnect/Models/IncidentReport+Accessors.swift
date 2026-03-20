//
//  IncidentReport+Accessors.swift
//  NurseryConnect
//
//  Purpose: Typed accessors for incident enums stored as strings.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import Foundation

// MARK: - Typed fields

extension IncidentReport {
    /// Parsed incident category.
    var incidentCategory: IncidentCategory? {
        IncidentCategory(rawValue: incidentCategoryRaw)
    }

    /// Parsed workflow status.
    var incidentStatus: IncidentStatus? {
        IncidentStatus(rawValue: statusRaw)
    }
}

extension BodyMapMarker {
    /// Parsed silhouette side.
    var bodySide: BodySide? {
        BodySide(rawValue: sideRaw)
    }
}
