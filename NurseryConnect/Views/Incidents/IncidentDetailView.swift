//
//  IncidentDetailView.swift
//  NurseryConnect
//
//  Purpose: Read-only incident review with notification simulation and export.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import SwiftUI

// MARK: - IncidentDetailView

/// Presents a single incident with body map and workflow context.
struct IncidentDetailView: View {
    /// Identifier resolved against the shared incident view model.
    let reportId: UUID
    @EnvironmentObject private var incidentViewModel: IncidentViewModel
    @State private var bodyMapSide = BodySide.front
    @State private var didCopySummary = false

    var body: some View {
        Group {
            if let report = resolvedReport {
                content(for: report)
            } else {
                Text("Incident not found.")
                    .foregroundStyle(Color.textSecondary)
            }
        }
        .navigationTitle("Incident")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            incidentViewModel.refresh()
        }
    }

    /// Resolves the latest model instance from the view model cache.
    private var resolvedReport: IncidentReport? {
        incidentViewModel.incidents.first(where: { $0.id == reportId })
    }

    @ViewBuilder
    private func content(for report: IncidentReport) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if report.incidentStatus == .draft {
                    NavigationLink {
                        NewIncidentReportView(resumeReport: report)
                    } label: {
                        Text("Continue editing draft")
                            .font(.headline.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.primaryTeal.opacity(0.15))
                            .foregroundStyle(Color.primaryTeal)
                            .clipShape(RoundedRectangle(cornerRadius: LayoutConstants.cardCornerRadius, style: .continuous))
                    }
                }
                statusTimeline(for: report)
                InfoCardView(title: "Child", content: report.childName, icon: "person.fill")
                InfoCardView(
                    title: "Category",
                    content: report.incidentCategory?.displayTitle ?? "—",
                    icon: "exclamationmark.bubble.fill"
                )
                InfoCardView(title: "Location", content: report.incidentLocation, icon: "mappin.circle.fill")
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Reported")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Color.textSecondary)
                        Spacer()
                        TimestampComplianceInfoButton()
                    }
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "clock.fill")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(Color.primaryTeal)
                            .frame(width: LayoutConstants.minimumTapTarget, height: LayoutConstants.minimumTapTarget)
                            .accessibilityHidden(true)
                        Text(report.reportedAt.ncFormattedDateTime())
                            .font(.body)
                            .foregroundStyle(Color.textPrimary)
                    }
                    .padding(LayoutConstants.horizontalPadding)
                    .ncCardStyle()
                }
                InfoCardView(title: "Reporter", content: report.keyworkerName, icon: "person.crop.circle")
                InfoCardView(title: "Description", content: report.incidentDescription, icon: "text.alignleft")
                InfoCardView(title: "Immediate action", content: report.immediateActionTaken, icon: "cross.case.fill")
                InfoCardView(
                    title: "Witnesses",
                    content: report.witnesses.isEmpty ? "None recorded" : report.witnesses.joined(separator: ", "),
                    icon: "person.3.fill"
                )
                bodyMapSection(for: report)
                if report.incidentStatus == .submittedForReview {
                    Button {
                        let success = incidentViewModel.markParentNotified(report: report)
                        if success {
                            incidentViewModel.refresh()
                        }
                    } label: {
                        Text("Parent Notified")
                            .font(.headline.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.warningAmber)
                            .foregroundStyle(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: LayoutConstants.cardCornerRadius, style: .continuous))
                    }
                    .accessibilityLabel(Text("Simulate parent notification"))
                }
                Button {
                    let text = incidentViewModel.exportSummary(for: report)
                    ClipboardService.copyToPasteboard(text: text)
                    didCopySummary = true
                } label: {
                    Text("Export Text Summary")
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
                if didCopySummary {
                    Text("Copied to clipboard")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.successGreen)
                }
            }
            .padding(.horizontal, LayoutConstants.horizontalPadding)
            .padding(.vertical, LayoutConstants.verticalPadding)
        }
        .background(Color.softBackground)
    }

    private func statusTimeline(for report: IncidentReport) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Status timeline")
                .font(.headline.weight(.semibold))
            IncidentStatusStepRow(title: "Draft", isComplete: statusRank(report.incidentStatus) >= statusRank(.draft))
            IncidentStatusStepRow(
                title: "Submitted",
                isComplete: statusRank(report.incidentStatus) >= statusRank(.submittedForReview)
            )
            IncidentStatusStepRow(
                title: "Parent notified",
                isComplete: statusRank(report.incidentStatus) >= statusRank(.parentNotified)
            )
            IncidentStatusStepRow(
                title: "Acknowledged",
                isComplete: statusRank(report.incidentStatus) >= statusRank(.acknowledged)
            )
        }
        .padding()
        .ncCardStyle()
    }

    private func statusRank(_ status: IncidentStatus?) -> Int {
        guard let status else {
            return 0
        }
        switch status {
        case .draft:
            return 1
        case .submittedForReview:
            return 2
        case .parentNotified:
            return 3
        case .acknowledged:
            return 4
        }
    }

    private func bodyMapSection(for report: IncidentReport) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Body map")
                .font(.headline.weight(.semibold))
            Picker("Side", selection: $bodyMapSide) {
                ForEach(BodySide.allCases, id: \.self) { side in
                    Text(side.displayTitle).tag(side)
                }
            }
            .pickerStyle(.segmented)
            GeometryReader { proxy in
                ZStack {
                    BodySilhouetteShape(side: bodyMapSide)
                        .stroke(Color.textSecondary.opacity(0.6), lineWidth: 2)
                        .background(
                            BodySilhouetteShape(side: bodyMapSide)
                                .fill(Color.primaryTeal.opacity(0.08))
                        )
                    ForEach(report.markers.filter { marker in
                        marker.bodySide == bodyMapSide
                    }, id: \.id) { marker in
                        Text(markerNumber(for: marker, in: report))
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(Color.white)
                            .frame(width: 22, height: 22)
                            .background(Color.alertRed)
                            .clipShape(Circle())
                            .position(
                                x: CGFloat(marker.xPosition) * proxy.size.width,
                                y: CGFloat(marker.yPosition) * proxy.size.height
                            )
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .aspectRatio(0.55, contentMode: .fit)
            ForEach(report.markers, id: \.id) { marker in
                VStack(alignment: .leading, spacing: 4) {
                    Text("Marker \(markerNumber(for: marker, in: report)) — \(marker.bodySide?.displayTitle ?? "")")
                        .font(.caption.weight(.semibold))
                    Text(marker.note.isEmpty ? "No note" : marker.note)
                        .font(.caption)
                        .foregroundStyle(Color.textSecondary)
                }
            }
        }
        .padding()
        .ncCardStyle()
    }

    private func markerNumber(for marker: BodyMapMarker, in report: IncidentReport) -> String {
        if let index = report.markers.firstIndex(where: { $0.id == marker.id }) {
            return "\(index + 1)"
        }
        return "—"
    }
}

// MARK: - IncidentStatusStepRow

private struct IncidentStatusStepRow: View {
    let title: String
    let isComplete: Bool

    var body: some View {
        HStack {
            Image(systemName: isComplete ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(isComplete ? Color.successGreen : Color.textSecondary)
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.textPrimary)
        }
    }
}

#Preview {
    NavigationStack {
        IncidentDetailView(reportId: UUID())
    }
    .environmentObject(IncidentViewModel())
    .modelContainer(for: [Child.self, DiaryEntry.self, IncidentReport.self, BodyMapMarker.self], inMemory: true)
}
