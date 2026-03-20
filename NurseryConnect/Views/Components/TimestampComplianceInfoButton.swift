//
//  TimestampComplianceInfoButton.swift
//  NurseryConnect
//
//  Purpose: Info affordance explaining automatic EYFS timestamp locking.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import SwiftUI

// MARK: - TimestampComplianceInfoButton

/// Tappable info icon revealing statutory timestamp guidance.
struct TimestampComplianceInfoButton: View {
    @State private var isPresentingInfo = false

    var body: some View {
        Button {
            isPresentingInfo = true
        } label: {
            Image(systemName: "info.circle")
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color.primaryTeal)
                .frame(width: LayoutConstants.minimumTapTarget, height: LayoutConstants.minimumTapTarget)
        }
        .accessibilityLabel(Text("Timestamp compliance information"))
        .popover(isPresented: $isPresentingInfo) {
            Text(
                "Timestamp is automatically recorded and cannot be modified to comply with EYFS statutory requirements."
            )
            .font(.footnote)
            .padding()
            .frame(minWidth: 260)
        }
    }
}

#Preview {
    TimestampComplianceInfoButton()
}
