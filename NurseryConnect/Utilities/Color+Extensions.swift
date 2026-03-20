//
//  Color+Extensions.swift
//  NurseryConnect
//
//  Purpose: Semantic colours mapped from asset catalog entries.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import SwiftUI

// MARK: - BrandColors

extension Color {
    /// Primary brand teal from assets.
    static let primaryTeal = Color("PrimaryTeal")
    /// Soft screen background from assets.
    static let softBackground = Color("SoftBackground")
    /// Card surface colour from assets.
    static let cardBackground = Color("CardBackground")
    /// Strong alert red for allergies and serious states.
    static let alertRed = Color("AlertRed")
    /// Amber for moderate warnings.
    static let warningAmber = Color("WarningAmber")
    /// Positive confirmation green.
    static let successGreen = Color("SuccessGreen")
    /// Primary readable text colour.
    static let textPrimary = Color("TextPrimary")
    /// Secondary descriptive text colour.
    static let textSecondary = Color("TextSecondary")
}

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
