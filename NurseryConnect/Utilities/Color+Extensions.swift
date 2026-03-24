//
//  Color+Extensions.swift
//  NurseryConnect
//
//  Purpose: Incident category styling; brand colours come from the asset catalog
//  (Swift-generated `Color` symbols — do not redeclare them here).
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import SwiftUI

// MARK: - IncidentCategorySeverity

extension IncidentCategory {
    /// Colour used on incident list badges to hint at severity.
    var badgeColor: Color {
        switch self {
        case .accidentMinor:
            return .warningAmber
        case .accidentFirstAid:
            return .alertRed
        case .safeguardingConcern:
            return .alertRed
        case .nearMiss:
            return .warningAmber
        case .allergicReaction:
            return .alertRed
        case .medicalIncident:
            return .alertRed
        }
    }
}
