//
//  SectionHeaderView.swift
//  NurseryConnect
//
//  Purpose: Title and optional subtitle stack for grouped content.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import SwiftUI

// MARK: - SectionHeaderView

/// Standard section heading with optional supporting text.
struct SectionHeaderView: View {
    /// Primary heading.
    let title: String
    /// Secondary line, hidden when nil.
    let subtitle: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline.weight(.semibold))
                .foregroundStyle(Color.textPrimary)
            if let subtitle, !subtitle.isEmpty {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(Color.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    SectionHeaderView(title: "Today’s diary", subtitle: "Chronological care log")
        .padding()
}
