//
//  StatusBadgeView.swift
//  NurseryConnect
//
//  Purpose: Compact pill showing incident workflow status.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import SwiftUI

// MARK: - StatusBadgeView

/// Colour-coded incident status chip.
struct StatusBadgeView: View {
    /// Status to render.
    let status: IncidentStatus

    var body: some View {
        Text(status.displayTitle)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(backgroundColor.opacity(0.15))
            .foregroundStyle(backgroundColor)
            .clipShape(Capsule())
            .accessibilityLabel(Text("Status \(status.displayTitle)"))
    }

    private var backgroundColor: Color {
        switch status {
        case .draft:
            return .textSecondary
        case .submittedForReview:
            return .warningAmber
        case .parentNotified:
            return .primaryTeal
        case .acknowledged:
            return .successGreen
        }
    }
}

#Preview {
    VStack {
        StatusBadgeView(status: .draft)
        StatusBadgeView(status: .submittedForReview)
    }
}
