//
//  FormStepIndicator.swift
//  NurseryConnect
//
//  Purpose: Shows progress through a multi-step incident wizard.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import SwiftUI

// MARK: - FormStepIndicator

/// Textual step counter for guided forms.
struct FormStepIndicator: View {
    /// Zero-based current step.
    let currentStep: Int
    /// Total steps in the flow.
    let totalSteps: Int

    var body: some View {
        Text("Step \(displayIndex) of \(totalSteps)")
            .font(.caption.weight(.semibold))
            .foregroundStyle(Color.textSecondary)
            .accessibilityLabel(Text("Step \(displayIndex) of \(totalSteps)"))
    }

    private var displayIndex: Int {
        min(max(currentStep + 1, 1), totalSteps)
    }
}

#Preview {
    FormStepIndicator(currentStep: 1, totalSteps: 4)
}
