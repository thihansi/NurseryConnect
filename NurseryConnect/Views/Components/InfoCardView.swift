//
//  InfoCardView.swift
//  NurseryConnect
//
//  Purpose: Icon-led summary card for read-only fact blocks.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import SwiftUI

// MARK: - InfoCardView

/// Horizontal icon + title + body card.
struct InfoCardView: View {
    /// Leading SF Symbol name.
    let title: String
    /// Main copy.
    let content: String
    /// Symbol image name.
    let icon: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3.weight(.semibold))
                .foregroundStyle(Color.primaryTeal)
                .frame(width: LayoutConstants.minimumTapTarget, height: LayoutConstants.minimumTapTarget)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(Color.textPrimary)
                Text(content)
                    .font(.subheadline)
                    .foregroundStyle(Color.textSecondary)
            }
            Spacer(minLength: 0)
        }
        .padding(LayoutConstants.horizontalPadding)
        .ncCardStyle()
    }
}

#Preview {
    InfoCardView(title: "Diet", content: "Vegetarian meals only.", icon: "leaf.fill")
        .padding()
        .background(Color.softBackground)
}
