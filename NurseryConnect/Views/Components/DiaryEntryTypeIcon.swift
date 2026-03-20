//
//  DiaryEntryTypeIcon.swift
//  NurseryConnect
//
//  Purpose: SF Symbol mapping for diary entry categories.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import SwiftUI

// MARK: - DiaryEntryTypeIcon

/// Renders the symbol for a diary type inside a tinted circle.
struct DiaryEntryTypeIcon: View {
    /// Diary category whose symbol should display.
    let type: DiaryEntryType

    var body: some View {
        Image(systemName: symbolName)
            .font(.headline)
            .foregroundStyle(Color.primaryTeal)
            .frame(width: LayoutConstants.minimumTapTarget - 4, height: LayoutConstants.minimumTapTarget - 4)
            .background(Color.primaryTeal.opacity(0.12))
            .clipShape(Circle())
            .accessibilityHidden(true)
    }

    private var symbolName: String {
        switch type {
        case .activity:
            return "figure.play"
        case .sleep:
            return "bed.double.fill"
        case .meal:
            return "fork.knife"
        case .nappy:
            return "drop.fill"
        case .wellbeing:
            return "heart.fill"
        case .milestone:
            return "star.fill"
        case .departure:
            return "arrow.right.circle.fill"
        case .arrival:
            return "arrow.left.circle.fill"
        }
    }
}

#Preview {
    DiaryEntryTypeIcon(type: .meal)
}
