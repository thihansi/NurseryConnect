//
//  DiaryViewModelTests.swift
//  NurseryConnectTests
//
//  Purpose: Validates diary persistence and validation helpers.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import SwiftData
@testable import NurseryConnect
import XCTest

// MARK: - DiaryViewModelTests

/// Unit coverage for `DiaryViewModel` CRUD helpers.
@MainActor
final class DiaryViewModelTests: XCTestCase {
    /// Builds an in-memory SwiftData stack for isolated tests.
    /// - Throws: Model creation errors.
    /// - Returns: Container and context tuple.
    private func makeContext() throws -> (ModelContainer, ModelContext) {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(
            for: Child.self,
            DiaryEntry.self,
            IncidentReport.self,
            BodyMapMarker.self,
            configurations: configuration
        )
        let context = ModelContext(container)
        return (container, context)
    }

    /// Confirms valid activity drafts persist and appear in today’s fetch.
    func testAddEntryAndFetchEntriesForChild() throws {
        let (_, context) = try makeContext()
        let child = Child(
            id: UUID(),
            fullName: "Test Child",
            preferredName: "Test",
            dateOfBirth: Date(),
            roomName: "Room",
            profileColorHex: "#2A7F7F",
            allergies: [],
            dietaryNotes: "",
            hasPhotographyConsent: true
        )
        context.insert(child)
        try context.save()

        let viewModel = DiaryViewModel(childId: child.id, modelContext: context)
        var draft = DiaryEntryDraft.empty(childId: child.id, entryType: .activity)
        draft.details = "Outdoor exploration"
        draft.eyfsArea = .understandingWorld

        XCTAssertTrue(viewModel.validateEntry(draft).isEmpty)
        XCTAssertTrue(viewModel.addEntry(draft))

        let entries = viewModel.fetchEntriesForChild(on: Date())
        XCTAssertEqual(entries.count, 1)
        XCTAssertEqual(entries.first?.details, "Outdoor exploration")
    }

    /// Ensures invalid drafts return validation messages and do not save.
    func testValidateEntryBlocksIncompleteActivity() throws {
        let (_, context) = try makeContext()
        let child = Child(
            id: UUID(),
            fullName: "Test Child",
            preferredName: "Test",
            dateOfBirth: Date(),
            roomName: "Room",
            profileColorHex: "#2A7F7F",
            allergies: [],
            dietaryNotes: "",
            hasPhotographyConsent: true
        )
        context.insert(child)
        try context.save()

        let viewModel = DiaryViewModel(childId: child.id, modelContext: context)
        var draft = DiaryEntryDraft.empty(childId: child.id, entryType: .activity)
        draft.details = ""
        draft.eyfsArea = nil

        let messages = viewModel.validateEntry(draft)
        XCTAssertFalse(messages.isEmpty)
        XCTAssertFalse(viewModel.addEntry(draft))
        XCTAssertTrue(viewModel.fetchEntriesForChild().isEmpty)
    }
}
