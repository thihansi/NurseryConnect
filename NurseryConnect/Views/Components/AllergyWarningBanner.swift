//
//  AllergyWarningBanner.swift
//  NurseryConnect
//
//  Purpose: High-visibility allergy alert strip for child-facing screens.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import SwiftUI

// MARK: - AllergyWarningBanner

/// Red banner listing allergens for safeguarding visibility.
struct AllergyWarningBanner: View {
    /// Allergen phrases to display; hidden when empty.
    let allergies: [String]

    var body: some View {
        if allergies.isEmpty {
            EmptyView()
        } else {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(Color.white)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Allergy alert")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(Color.white)
                    Text(allergies.joined(separator: ", "))
                        .font(.subheadline)
                        .foregroundStyle(Color.white.opacity(0.95))
                }
                Spacer(minLength: 0)
            }
            .padding(LayoutConstants.horizontalPadding)
            .background(Color.alertRed)
            .clipShape(RoundedRectangle(cornerRadius: LayoutConstants.cardCornerRadius, style: .continuous))
            .accessibilityElement(children: .combine)
            .accessibilityLabel(Text("Allergies: \(allergies.joined(separator: ", "))"))
        }
    }
}

#Preview {
    AllergyWarningBanner(allergies: ["Peanuts", "Tree Nuts"])
        .padding()
}
