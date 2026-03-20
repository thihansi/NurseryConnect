//
//  EmptyStateView.swift
//  NurseryConnect
//
//  Purpose: Illustrative empty list placeholder with SF Symbol artwork.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import SwiftUI

// MARK: - EmptyStateView

/// Centered empty state with icon, title, and supporting message.
struct EmptyStateView: View {
    /// Large SF Symbol name.
    let icon: String
    /// Primary heading.
    let title: String
    /// Supporting copy.
    let message: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 48, weight: .light))
                .foregroundStyle(Color.primaryTeal.opacity(0.6))
                .accessibilityHidden(true)
            Text(title)
                .font(.headline.weight(.semibold))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.textPrimary)
            Text(message)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.textSecondary)
        }
        .padding(LayoutConstants.horizontalPadding)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    EmptyStateView(icon: "tray", title: "No entries yet", message: "Add the first diary note for today.")
        .background(Color.softBackground)
}
