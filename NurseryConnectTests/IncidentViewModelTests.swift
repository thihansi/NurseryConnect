//
//  IncidentViewModelTests.swift
//  NurseryConnectTests
//
//  Purpose: Covers incident wizard validation and persistence rules.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import SwiftData
@testable import NurseryConnect
import XCTest

// MARK: - IncidentViewModelTests

/// Unit coverage for `IncidentViewModel`.
@MainActor
final class IncidentViewModelTests: XCTestCase {
    /// Creates an in-memory model stack with one child for lookups.
    /// - Returns: Context and inserted child.
    private func makeContextWithChild() throws -> (ModelContext, Child) {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(
            for: Child.self,
            DiaryEntry.self,
            IncidentReport.self,
            BodyMapMarker.self,
            configurations: configuration
        )
        let context = ModelContext(container)
        let child = Child(
            id: UUID(),
            fullName: "Casey Example",
            preferredName: "Casey",
            dateOfBirth: Date(),
            roomName: "Room",
            profileColorHex: "#2A7F7F",
            allergies: [],
            dietaryNotes: "",
            hasPhotographyConsent: true
        )
        context.insert(child)
        try context.save()
        return (context, child)
    }

    /// Verifies required-field validation catches missing copy.
    func testValidateRequiredFields() throws {
        let (context, _) = try makeContextWithChild()
        let viewModel = IncidentViewModel()
        viewModel.bind(modelContext: context)
        viewModel.resetWizard()

        let issues = viewModel.validateRequiredFields()
        XCTAssertFalse(issues.isEmpty)
    }

    /// Confirms submission succeeds when all required wizard fields are filled.
    func testSubmitReportPersistsSubmittedStatus() throws {
        let (context, child) = try makeContextWithChild()
        let viewModel = IncidentViewModel()
        viewModel.bind(modelContext: context)
        viewModel.resetWizard()
        viewModel.selectedChildId = child.id
        viewModel.selectedCategory = .nearMiss
        viewModel.incidentLocation = "Playground"
        viewModel.incidentDescription = "Loose bolt spotted on gate."
        viewModel.immediateActionTaken = "Area cordoned and manager informed."

        XCTAssertTrue(viewModel.validateRequiredFields().isEmpty)
        XCTAssertTrue(viewModel.submitReport())
        XCTAssertEqual(viewModel.incidents.count, 1)
        XCTAssertEqual(viewModel.incidents.first?.incidentStatus, .submittedForReview)
    }

    /// Confirms drafts can be saved with minimal mandatory selections.
    func testCreateReportSavesDraft() throws {
        let (context, child) = try makeContextWithChild()
        let viewModel = IncidentViewModel()
        viewModel.bind(modelContext: context)
        viewModel.resetWizard()
        viewModel.selectedChildId = child.id
        viewModel.selectedCategory = .accidentMinor

        XCTAssertTrue(viewModel.createReport())
        XCTAssertEqual(viewModel.incidents.first?.incidentStatus, .draft)
    }

    /// Flags stale drafts older than one hour for banner logic.
    func testDraftExceedsOneHour() throws {
        let (context, child) = try makeContextWithChild()
        let viewModel = IncidentViewModel()
        viewModel.bind(modelContext: context)
        let oldDate = Date().addingTimeInterval(-(60 * 60 + 60))
        let draft = IncidentReport(
            id: UUID(),
            childId: child.id,
            childName: child.fullName,
            keyworkerName: AppConstants.currentKeyworkerName,
            reportedAt: oldDate,
            incidentCategoryRaw: IncidentCategory.accidentMinor.rawValue,
            incidentLocation: "Hall",
            incidentDescription: "TBC",
            immediateActionTaken: "TBC",
            witnesses: [],
            statusRaw: IncidentStatus.draft.rawValue
        )
        context.insert(draft)
        try context.save()
        viewModel.refresh()

        XCTAssertTrue(viewModel.draftExceedsOneHour(now: Date()))
    }
}
