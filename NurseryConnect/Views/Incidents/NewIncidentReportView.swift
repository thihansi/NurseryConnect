//
//  NewIncidentReportView.swift
//  NurseryConnect
//
//  Purpose: Four-step incident wizard with body map and regulatory review.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import SwiftUI

// MARK: - NewIncidentReportView

/// Guided flow for drafting or submitting incidents.
struct NewIncidentReportView: View {
    /// Optional draft being resumed from detail.
    let resumeReport: IncidentReport?
    @EnvironmentObject private var incidentViewModel: IncidentViewModel
    @EnvironmentObject private var childListViewModel: ChildListViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var bodyMapSide = BodySide.front
    @State private var submitIssues: [String: String] = [:]
    @State private var didAttemptSubmit = false

    private let totalSteps = 4

    var body: some View {
        VStack(spacing: 12) {
            FormStepIndicator(currentStep: incidentViewModel.wizardStep, totalSteps: totalSteps)
                .padding(.top, 8)
            stepContent
            navigationControls
        }
        .padding(.horizontal, LayoutConstants.horizontalPadding)
        .background(Color.softBackground)
        .navigationTitle("New Incident")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            childListViewModel.refresh()
            if let resumeReport {
                incidentViewModel.loadDraftForEditing(resumeReport)
            } else {
                incidentViewModel.resetWizard()
            }
        }
    }

    @ViewBuilder
    private var stepContent: some View {
        switch incidentViewModel.wizardStep {
        case 0:
            stepOne
        case 1:
            stepTwo
        case 2:
            stepThree
        default:
            stepFour
        }
    }

    private var stepOne: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Picker("Child", selection: bindingChild) {
                    Text("Select child").tag(Optional<UUID>.none)
                    ForEach(childListViewModel.children, id: \.id) { child in
                        Text(child.preferredName).tag(Optional(child.id))
                    }
                }
                .accessibilityIdentifier("IncidentChildPicker")
                Picker("Category", selection: bindingCategory) {
                    Text("Select category").tag(Optional<IncidentCategory>.none)
                    ForEach(IncidentCategory.allCases, id: \.self) { category in
                        Text(category.displayTitle).tag(Optional(category))
                    }
                }
                .accessibilityIdentifier("IncidentCategoryPicker")
                if let category = incidentViewModel.selectedCategory {
                    Text(category.displayDescription)
                        .font(.caption)
                        .foregroundStyle(Color.textSecondary)
                }
                TextField("Location (e.g. Garden area)", text: $incidentViewModel.incidentLocation)
                    .textFieldStyle(.roundedBorder)
                    .accessibilityIdentifier("IncidentLocationField")
                HStack {
                    Text("Reported at \(incidentViewModel.reportAnchorTime.ncFormattedDateTime()) — cannot be changed")
                        .font(.caption)
                        .foregroundStyle(Color.textSecondary)
                    TimestampComplianceInfoButton()
                }
            }
        }
    }

    private var stepTwo: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Description")
                    .font(.headline.weight(.semibold))
                TextEditor(text: $incidentViewModel.incidentDescription)
                    .frame(minHeight: 120)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.textSecondary.opacity(0.2))
                    )
                    .accessibilityIdentifier("IncidentDescriptionField")
                Text("Immediate action taken")
                    .font(.headline.weight(.semibold))
                TextEditor(text: $incidentViewModel.immediateActionTaken)
                    .frame(minHeight: 120)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.textSecondary.opacity(0.2))
                    )
                    .accessibilityIdentifier("IncidentImmediateField")
                witnessEditor
            }
        }
    }

    private var stepThree: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                BodyMapView(side: $bodyMapSide, markers: incidentViewModel.markerDrafts) { point in
                    incidentViewModel.addMarker(normalizedPoint: point, side: bodyMapSide)
                }
                Button(role: .destructive) {
                    incidentViewModel.clearMarkers()
                } label: {
                    Text("Clear All Markers")
                        .frame(maxWidth: .infinity)
                }
                ForEach(incidentViewModel.markerDrafts) { marker in
                    VStack(alignment: .leading) {
                        Text("Marker \(marker.displayIndex)")
                            .font(.caption.weight(.semibold))
                        TextField("Note", text: bindingMarkerNote(marker.id))
                            .textFieldStyle(.roundedBorder)
                    }
                }
            }
        }
    }

    private var stepFour: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                summarySection(title: "Child", text: childNameLabel)
                summarySection(title: "Category", text: incidentViewModel.selectedCategory?.displayTitle ?? "—")
                summarySection(title: "Location", text: incidentViewModel.incidentLocation)
                summarySection(title: "Description", text: incidentViewModel.incidentDescription)
                summarySection(title: "Immediate action", text: incidentViewModel.immediateActionTaken)
                summarySection(title: "Witnesses", text: witnessSummary)
                VStack(alignment: .leading, spacing: 8) {
                    Text("⚠️ Regulatory Notice")
                        .font(.headline.weight(.semibold))
                    Text(
                        "Under EYFS statutory requirements, parents must be notified of all incidents on the same day. Submitting this report will flag it for manager review and trigger parent notification."
                    )
                    .font(.subheadline)
                    .foregroundStyle(Color.textSecondary)
                }
                .padding()
                .background(Color.warningAmber.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: LayoutConstants.cardCornerRadius, style: .continuous))
                if didAttemptSubmit {
                    ForEach(Array(submitIssues.keys), id: \.self) { key in
                        if let message = submitIssues[key] {
                            Text(message)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(Color.alertRed)
                        }
                    }
                }
                Button {
                    attemptSubmit()
                } label: {
                    Text("Submit for Manager Review")
                        .font(.headline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primaryTeal)
                        .foregroundStyle(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: LayoutConstants.cardCornerRadius, style: .continuous))
                }
                .accessibilityIdentifier("IncidentSubmitReview")
                Button {
                    let saved = incidentViewModel.createReport()
                    if saved {
                        dismiss()
                    }
                } label: {
                    Text("Save as Draft")
                        .font(.headline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.cardBackground)
                        .foregroundStyle(Color.primaryTeal)
                        .clipShape(RoundedRectangle(cornerRadius: LayoutConstants.cardCornerRadius, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: LayoutConstants.cardCornerRadius)
                                .stroke(Color.primaryTeal, lineWidth: 1)
                        )
                }
            }
        }
    }

    private var witnessEditor: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Witnesses")
                .font(.headline.weight(.semibold))
            ForEach(incidentViewModel.witnessNames.indices, id: \.self) { index in
                TextField("Witness name", text: bindingWitness(index))
                    .textFieldStyle(.roundedBorder)
            }
            Button {
                incidentViewModel.addWitnessRow()
            } label: {
                Text("Add Witness")
            }
        }
    }

    private var navigationControls: some View {
        HStack {
            Button("Back") {
                incidentViewModel.wizardStep = max(incidentViewModel.wizardStep - 1, 0)
            }
            .disabled(incidentViewModel.wizardStep == 0)
            Spacer()
            if incidentViewModel.wizardStep < totalSteps - 1 {
                Button("Next") {
                    advanceStep()
                }
                .disabled(!canAdvanceFromCurrentStep())
                .accessibilityIdentifier("IncidentWizardNext")
            }
        }
        .padding(.bottom, 12)
    }

    private var childNameLabel: String {
        guard let id = incidentViewModel.selectedChildId else {
            return "—"
        }
        return childListViewModel.children.first(where: { $0.id == id })?.fullName ?? "—"
    }

    private var witnessSummary: String {
        let names = incidentViewModel.witnessNames
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        return names.isEmpty ? "None recorded" : names.joined(separator: ", ")
    }

    private func summarySection(title: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color.textSecondary)
            Text(text)
                .font(.body)
                .foregroundStyle(Color.textPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .ncCardStyle()
    }

    private func bindingWitness(_ index: Int) -> Binding<String> {
        Binding(
            get: {
                guard incidentViewModel.witnessNames.indices.contains(index) else {
                    return ""
                }
                return incidentViewModel.witnessNames[index]
            },
            set: { newValue in
                guard incidentViewModel.witnessNames.indices.contains(index) else {
                    return
                }
                incidentViewModel.witnessNames[index] = newValue
            }
        )
    }

    private func bindingMarkerNote(_ id: UUID) -> Binding<String> {
        Binding(
            get: {
                incidentViewModel.markerDrafts.first(where: { $0.id == id })?.note ?? ""
            },
            set: { newValue in
                incidentViewModel.updateMarkerNote(id: id, note: newValue)
            }
        )
    }

    private var bindingChild: Binding<UUID?> {
        Binding(
            get: { incidentViewModel.selectedChildId },
            set: { incidentViewModel.selectedChildId = $0 }
        )
    }

    private var bindingCategory: Binding<IncidentCategory?> {
        Binding(
            get: { incidentViewModel.selectedCategory },
            set: { incidentViewModel.selectedCategory = $0 }
        )
    }

    private func canAdvanceFromCurrentStep() -> Bool {
        switch incidentViewModel.wizardStep {
        case 0:
            let location = incidentViewModel.incidentLocation.trimmingCharacters(in: .whitespacesAndNewlines)
            return incidentViewModel.selectedChildId != nil
                && incidentViewModel.selectedCategory != nil
                && !location.isEmpty
        default:
            return true
        }
    }

    private func advanceStep() {
        guard canAdvanceFromCurrentStep() else {
            return
        }
        incidentViewModel.wizardStep = min(incidentViewModel.wizardStep + 1, totalSteps - 1)
    }

    private func attemptSubmit() {
        didAttemptSubmit = true
        submitIssues = incidentViewModel.validateRequiredFields()
        if !submitIssues.isEmpty {
            return
        }
        let success = incidentViewModel.submitReport()
        if success {
            dismiss()
        }
    }
}

#Preview {
    NavigationStack {
        NewIncidentReportView(resumeReport: nil)
    }
    .environmentObject(IncidentViewModel())
    .environmentObject(ChildListViewModel())
    .modelContainer(for: [Child.self, DiaryEntry.self, IncidentReport.self, BodyMapMarker.self], inMemory: true)
}
