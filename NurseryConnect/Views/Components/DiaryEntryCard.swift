//
//  DiaryEntryCard.swift
//  NurseryConnect
//
//  Purpose: Timeline row styling for a single diary entry.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import SwiftUI

// MARK: - DiaryEntryCard

/// Card used in the chronological diary list.
struct DiaryEntryCard: View {
    /// Persisted diary row.
    let entry: DiaryEntry

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if let type = entry.entryType {
                DiaryEntryTypeIcon(type: type)
            } else {
                Image(systemName: "questionmark.circle")
                    .font(.headline)
                    .frame(width: LayoutConstants.minimumTapTarget - 4, height: LayoutConstants.minimumTapTarget - 4)
            }
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(entry.timestamp.ncFormattedShortTime())
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.textSecondary)
                    if let type = entry.entryType {
                        Text(type.displayTitle)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Color.textPrimary)
                    }
                    Spacer(minLength: 0)
                    TimestampComplianceInfoButton()
                }
                Text(entry.details)
                    .font(.subheadline)
                    .foregroundStyle(Color.textPrimary)
                    .lineLimit(3)
            }
        }
        .padding(LayoutConstants.horizontalPadding)
        .ncCardStyle()
    }
}

#Preview {
    DiaryEntryCard(
        entry: DiaryEntry(
            id: UUID(),
            childId: UUID(),
            timestamp: Date(),
            entryTypeRaw: DiaryEntryType.meal.rawValue,
            details: "Lunch eaten well with water."
        )
    )
    .padding()
    .background(Color.softBackground)
}
