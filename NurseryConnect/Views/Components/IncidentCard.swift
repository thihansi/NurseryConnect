//
//  IncidentCard.swift
//  NurseryConnect
//
//  Purpose: Summary card for incident list rows.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import SwiftUI

// MARK: - IncidentCard

/// List cell for an incident with category tinting.
struct IncidentCard: View {
    /// Backing incident model.
    let report: IncidentReport

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(report.childName)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(Color.textPrimary)
                Spacer(minLength: 0)
                if let status = report.incidentStatus {
                    StatusBadgeView(status: status)
                }
            }
            if let category = report.incidentCategory {
                Text(category.displayTitle)
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(category.badgeColor.opacity(0.15))
                    .foregroundStyle(category.badgeColor)
                    .clipShape(Capsule())
            }
            Text(report.reportedAt.ncFormattedDateTime())
                .font(.caption)
                .foregroundStyle(Color.textSecondary)
        }
        .padding(LayoutConstants.horizontalPadding)
        .ncCardStyle()
    }
}

#Preview {
    let report = IncidentReport(
        id: UUID(),
        childId: UUID(),
        childName: "Oliver James Patel",
        keyworkerName: AppConstants.currentKeyworkerName,
        reportedAt: Date(),
        incidentCategoryRaw: IncidentCategory.accidentMinor.rawValue,
        incidentLocation: "Garden",
        incidentDescription: "Minor trip.",
        immediateActionTaken: "Plaster applied.",
        witnesses: [],
        statusRaw: IncidentStatus.submittedForReview.rawValue
    )
    return IncidentCard(report: report)
        .padding()
        .background(Color.softBackground)
}
