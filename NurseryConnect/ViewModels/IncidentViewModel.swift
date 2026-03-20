//
//  IncidentViewModel.swift
//  NurseryConnect
//
//  Purpose: Incident list filtering, wizard persistence, and regulatory checks.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import Combine
import Foundation
import SwiftData

// MARK: - IncidentPersistenceIntent

/// Whether the wizard should save quietly or escalate for review.
enum IncidentPersistenceIntent {
    case saveDraft
    case submitForReview
}

// MARK: - IncidentViewModel

/// Central coordinator for incident CRUD, filtering, and wizard state.
@MainActor
final class IncidentViewModel: ObservableObject {
    // MARK: List

    /// Cached incidents for the keyworker.
    @Published private(set) var incidents: [IncidentReport] = []
    /// Active list segmentation.
    @Published var listFilter: IncidentListFilter = .all
    /// True when a draft is older than the regulatory reminder window.
    @Published var showDraftStaleBanner = false

    // MARK: Wizard

    /// Zero-based wizard step index.
    @Published var wizardStep: Int = 0
    /// Immutable timestamp shown throughout the wizard.
    @Published var reportAnchorTime: Date = Date()
    /// Selected child identifier.
    @Published var selectedChildId: UUID?
    /// Selected taxonomy value.
    @Published var selectedCategory: IncidentCategory?
    /// Location description within the setting.
    @Published var incidentLocation: String = ""
    /// Narrative of the event.
    @Published var incidentDescription: String = ""
    /// First response description.
    @Published var immediateActionTaken: String = ""
    /// Witness name rows; blanks are ignored on save.
    @Published var witnessNames: [String] = [""]
    /// Tap markers before persistence.
    @Published var markerDrafts: [BodyMapMarkerDraft] = []
    /// When non-nil, wizard updates an existing incident.
    @Published var editingReportId: UUID?

    private var modelContext: ModelContext?

    /// Creates a view model awaiting context binding.
    init() {}

    /// Binds the SwiftData context and performs an initial refresh.
    /// - Parameter context: Environment model context.
    func bind(modelContext context: ModelContext) {
        if modelContext == nil {
            modelContext = context
            refresh()
        }
    }

    /// Reloads incidents from disk newest-first.
    func refresh() {
        guard let modelContext else {
            return
        }
        let descriptor = FetchDescriptor<IncidentReport>(
            sortBy: [SortDescriptor(\IncidentReport.reportedAt, order: .reverse)]
        )
        do {
            incidents = try modelContext.fetch(descriptor)
        } catch {
            incidents = []
        }
        updateStaleDraftBanner()
    }

    /// Applies the selected list filter.
    /// - Returns: Sorted incidents for display.
    func filteredIncidents() -> [IncidentReport] {
        let calendar = Calendar.current
        let today = Date()
        switch listFilter {
        case .all:
            return incidents
        case .today:
            return incidents.filter { $0.reportedAt.ncIsSameDay(as: today, calendar: calendar) }
        case .pendingReview:
            return incidents.filter { report in
                guard let status = report.incidentStatus else {
                    return false
                }
                return status == .draft || status == .submittedForReview
            }
        }
    }

    /// Counts draft incidents for the tab badge.
    /// - Returns: Draft-only count.
    func draftBadgeCount() -> Int {
        incidents.filter { $0.incidentStatus == .draft }.count
    }

    /// Detects drafts older than one hour for the regulatory banner.
    /// - Returns: True when at least one stale draft exists.
    func draftExceedsOneHour(now: Date = Date()) -> Bool {
        let windowSeconds = LayoutConstants.draftIncidentStaleHours * 60 * 60
        let threshold = now.addingTimeInterval(-windowSeconds)
        return incidents.contains { report in
            guard report.incidentStatus == .draft else {
                return false
            }
            return report.reportedAt < threshold
        }
    }

    /// Refreshes the banner flag from persisted incidents.
    func updateStaleDraftBanner() {
        showDraftStaleBanner = draftExceedsOneHour()
    }

    /// Validates fields required before manager submission.
    /// - Returns: Keys mapped to user-visible errors.
    func validateRequiredFields() -> [String: String] {
        var messages: [String: String] = [:]
        if selectedChildId == nil {
            messages["child"] = "Select a child."
        }
        if selectedCategory == nil {
            messages["category"] = "Select a category."
        }
        let location = incidentLocation.trimmingCharacters(in: .whitespacesAndNewlines)
        if location.isEmpty {
            messages["location"] = "Add a location."
        }
        let description = incidentDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        if description.isEmpty {
            messages["description"] = "Describe what happened."
        }
        let immediate = immediateActionTaken.trimmingCharacters(in: .whitespacesAndNewlines)
        if immediate.isEmpty {
            messages["immediateAction"] = "Record immediate actions taken."
        }
        return messages
    }

    /// Resets the wizard for a brand-new report.
    func resetWizard() {
        wizardStep = 0
        reportAnchorTime = Date()
        selectedChildId = nil
        selectedCategory = nil
        incidentLocation = ""
        incidentDescription = ""
        immediateActionTaken = ""
        witnessNames = [""]
        markerDrafts = []
        editingReportId = nil
    }

    /// Hydrates the wizard from an existing draft report.
    /// - Parameter report: Draft row loaded from SwiftData.
    func loadDraftForEditing(_ report: IncidentReport) {
        guard report.incidentStatus == .draft else {
            return
        }
        editingReportId = report.id
        reportAnchorTime = report.reportedAt
        selectedChildId = report.childId
        selectedCategory = report.incidentCategory
        incidentLocation = report.incidentLocation
        incidentDescription = report.incidentDescription
        immediateActionTaken = report.immediateActionTaken
        witnessNames = report.witnesses.isEmpty ? [""] : report.witnesses
        markerDrafts = report.markers.enumerated().map { index, marker in
            let side = marker.bodySide ?? .front
            return BodyMapMarkerDraft(
                id: marker.id,
                xPosition: marker.xPosition,
                yPosition: marker.yPosition,
                side: side,
                note: marker.note,
                displayIndex: index + 1
            )
        }
        wizardStep = 0
    }

    /// Appends a blank witness row.
    func addWitnessRow() {
        witnessNames.append("")
    }

    /// Removes a witness row when more than one exists.
    /// - Parameter index: Index to remove.
    func removeWitnessRow(at index: Int) {
        guard witnessNames.indices.contains(index), witnessNames.count > 1 else {
            return
        }
        witnessNames.remove(at: index)
    }

    /// Adds a numbered marker for the active silhouette.
    /// - Parameters:
    ///   - normalizedPoint: Tap in unit space.
    ///   - side: Active silhouette.
    func addMarker(normalizedPoint: CGPoint, side: BodySide) {
        let nextIndex = markerDrafts.count + 1
        let draft = BodyMapMarkerDraft(
            id: UUID(),
            xPosition: Double(normalizedPoint.x),
            yPosition: Double(normalizedPoint.y),
            side: side,
            note: "",
            displayIndex: nextIndex
        )
        markerDrafts.append(draft)
    }

    /// Clears all tap markers in the wizard.
    func clearMarkers() {
        markerDrafts = []
    }

    /// Updates the note text for a marker.
    /// - Parameters:
    ///   - id: Marker identifier.
    ///   - note: Replacement text.
    func updateMarkerNote(id: UUID, note: String) {
        guard let index = markerDrafts.firstIndex(where: { $0.id == id }) else {
            return
        }
        markerDrafts[index].note = note
    }

    /// Persists wizard content according to intent.
    /// - Parameter intent: Draft or submission path.
    /// - Returns: True when `save()` succeeded.
    @discardableResult
    func persistWizard(intent: IncidentPersistenceIntent) -> Bool {
        guard let modelContext else {
            return false
        }
        if intent == .submitForReview {
            let issues = validateRequiredFields()
            if !issues.isEmpty {
                return false
            }
        } else {
            var draftIssues: [String: String] = [:]
            if selectedChildId == nil {
                draftIssues["child"] = "Select a child before saving a draft."
            }
            if selectedCategory == nil {
                draftIssues["category"] = "Select a category before saving a draft."
            }
            if !draftIssues.isEmpty {
                return false
            }
        }
        let childName = resolvedChildName(in: modelContext) ?? "Unknown child"
        let witnesses = sanitizedWitnesses()
        let status: IncidentStatus = intent == .submitForReview ? .submittedForReview : .draft
        if let editingReportId {
            return updateExistingReport(
                id: editingReportId,
                childName: childName,
                witnesses: witnesses,
                status: status,
                modelContext: modelContext
            )
        } else {
            return insertNewReport(
                childName: childName,
                witnesses: witnesses,
                status: status,
                modelContext: modelContext
            )
        }
    }

    /// Persists a new or updated incident as **draft** (assignment-facing alias).
    /// - Returns: True when the save succeeds.
    @discardableResult
    func createReport() -> Bool {
        persistWizard(intent: .saveDraft)
    }

    /// Submits the wizard for manager review with full validation.
    /// - Returns: True when validation passes and save succeeds.
    @discardableResult
    func submitReport() -> Bool {
        persistWizard(intent: .submitForReview)
    }

    /// Simulates parent notification for a submitted incident.
    /// - Parameter report: Target incident.
    /// - Returns: True when persistence succeeds.
    @discardableResult
    func markParentNotified(report: IncidentReport) -> Bool {
        guard let modelContext else {
            return false
        }
        guard report.incidentStatus == .submittedForReview else {
            return false
        }
        report.parentNotifiedAt = Date()
        report.statusRaw = IncidentStatus.parentNotified.rawValue
        do {
            try modelContext.save()
            refresh()
            return true
        } catch {
            return false
        }
    }

    /// Builds a plain-text export suitable for email or notes apps.
    /// - Parameter report: Incident to summarise.
    /// - Returns: Multi-line description.
    func exportSummary(for report: IncidentReport) -> String {
        let categoryTitle = report.incidentCategory?.displayTitle ?? "Unknown"
        let statusTitle = report.incidentStatus?.displayTitle ?? "Unknown"
        let notified: String
        if let date = report.parentNotifiedAt {
            notified = date.ncFormattedDateTime()
        } else {
            notified = "Not recorded"
        }
        let witnessBlock = report.witnesses.joined(separator: ", ")
        let markerBlock = report.markers.enumerated().map { index, marker in
            let side = marker.bodySide?.displayTitle ?? "Side"
            return "\(index + 1). \(side) @ (\(formatCoordinate(marker.xPosition)), \(formatCoordinate(marker.yPosition))) — \(marker.note)"
        }.joined(separator: "\n")
        return """
        Incident report
        Child: \(report.childName)
        Category: \(categoryTitle)
        Status: \(statusTitle)
        Reported: \(report.reportedAt.ncFormattedDateTime())
        Reporter: \(report.keyworkerName)
        Location: \(report.incidentLocation)

        Description:
        \(report.incidentDescription)

        Immediate action:
        \(report.immediateActionTaken)

        Witnesses: \(witnessBlock)

        Body markers:
        \(markerBlock)

        Parent notified at: \(notified)
        """
    }

    // MARK: Private helpers

    private func formatCoordinate(_ value: Double) -> String {
        String(format: "%.2f", value)
    }

    private func sanitizedWitnesses() -> [String] {
        witnessNames
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    private func resolvedChildName(in context: ModelContext) -> String? {
        guard let childId = selectedChildId else {
            return nil
        }
        let childUUID = childId
        let predicate = #Predicate<Child> { $0.id == childUUID }
        var descriptor = FetchDescriptor<Child>(predicate: predicate)
        descriptor.fetchLimit = 1
        do {
            let child = try context.fetch(descriptor).first
            return child?.fullName
        } catch {
            return nil
        }
    }

    private func insertNewReport(
        childName: String,
        witnesses: [String],
        status: IncidentStatus,
        modelContext: ModelContext
    ) -> Bool {
        guard let childId = selectedChildId else {
            return false
        }
        guard let category = selectedCategory else {
            return false
        }
        let report = IncidentReport(
            id: UUID(),
            childId: childId,
            childName: childName,
            keyworkerName: AppConstants.currentKeyworkerName,
            reportedAt: reportAnchorTime,
            incidentCategoryRaw: category.rawValue,
            incidentLocation: incidentLocation.trimmingCharacters(in: .whitespacesAndNewlines),
            incidentDescription: incidentDescription.trimmingCharacters(in: .whitespacesAndNewlines),
            immediateActionTaken: immediateActionTaken.trimmingCharacters(in: .whitespacesAndNewlines),
            witnesses: witnesses,
            statusRaw: status.rawValue,
            parentNotifiedAt: nil,
            markers: []
        )
        modelContext.insert(report)
        _ = makeMarkers(for: report, context: modelContext)
        do {
            try modelContext.save()
            refresh()
            resetWizard()
            return true
        } catch {
            modelContext.delete(report)
            return false
        }
    }

    private func updateExistingReport(
        id: UUID,
        childName: String,
        witnesses: [String],
        status: IncidentStatus,
        modelContext: ModelContext
    ) -> Bool {
        let targetId = id
        let predicate = #Predicate<IncidentReport> { $0.id == targetId }
        var descriptor = FetchDescriptor<IncidentReport>(predicate: predicate)
        descriptor.fetchLimit = 1
        do {
            guard let report = try modelContext.fetch(descriptor).first else {
                return false
            }
            if let childId = selectedChildId {
                report.childId = childId
            }
            report.childName = childName
            if let category = selectedCategory {
                report.incidentCategoryRaw = category.rawValue
            }
            report.incidentLocation = incidentLocation.trimmingCharacters(in: .whitespacesAndNewlines)
            report.incidentDescription = incidentDescription.trimmingCharacters(in: .whitespacesAndNewlines)
            report.immediateActionTaken = immediateActionTaken.trimmingCharacters(in: .whitespacesAndNewlines)
            report.witnesses = witnesses
            report.statusRaw = status.rawValue
            let existingMarkers = report.markers
            for marker in existingMarkers {
                modelContext.delete(marker)
            }
            report.markers = []
            _ = makeMarkers(for: report, context: modelContext)
            try modelContext.save()
            refresh()
            resetWizard()
            return true
        } catch {
            return false
        }
    }

    private func makeMarkers(for report: IncidentReport, context: ModelContext) -> [BodyMapMarker] {
        markerDrafts.map { draft in
            let marker = BodyMapMarker(
                id: draft.id,
                xPosition: draft.xPosition,
                yPosition: draft.yPosition,
                sideRaw: draft.side.rawValue,
                note: draft.note,
                incidentReport: report
            )
            context.insert(marker)
            return marker
        }
    }
}
