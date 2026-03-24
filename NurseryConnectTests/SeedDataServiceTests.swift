//
//  SeedDataServiceTests.swift
//  NurseryConnectTests
//
//  Purpose: Ensures bundled seed data is applied exactly once.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import SwiftData
@testable import NurseryConnect
import XCTest

// MARK: - SeedDataServiceTests

/// Validates idempotent behaviour of `SeedDataService`.
@MainActor
final class SeedDataServiceTests: XCTestCase {
    /// Resets the global seeding flag before each run.
    override func setUp() async throws {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.hasSeededNurseryConnectData)
    }

    /// Confirms a second seed pass does not duplicate rows.
    func testSeedIfNeededDoesNotDuplicate() async throws {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(
            for: Child.self,
            DiaryEntry.self,
            IncidentReport.self,
            BodyMapMarker.self,
            configurations: configuration
        )
        let context = ModelContext(container)

        await SeedDataService.seedIfNeeded(modelContext: context)
        let firstFetch = try context.fetch(FetchDescriptor<Child>())
        let firstCount = firstFetch.count

        await SeedDataService.seedIfNeeded(modelContext: context)
        let secondFetch = try context.fetch(FetchDescriptor<Child>())
        let secondCount = secondFetch.count

        XCTAssertEqual(firstCount, secondCount)
        XCTAssertTrue(UserDefaults.standard.bool(forKey: UserDefaultsKeys.hasSeededNurseryConnectData))
    }
}
