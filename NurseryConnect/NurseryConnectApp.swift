//
//  NurseryConnectApp.swift
//  NurseryConnect
//
//  Purpose: App entry point with SwiftData container and first-launch seeding.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import SwiftData
import SwiftUI

// MARK: - NurseryConnectApp

/// Root application type configuring persistence and the main tab interface.
@main
struct NurseryConnectApp: App {
    /// Shared SwiftData container for all persisted entities.
    private let modelContainer: ModelContainer

    /// Creates the app, building an in-memory or on-disk container.
    init() {
        let schema = Schema([
            Child.self,
            DiaryEntry.self,
            IncidentReport.self,
            BodyMapMarker.self
        ])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Failed to create ModelContainer: \(error.localizedDescription)")
        }
    }

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .modelContainer(modelContainer)
                .task {
                    let context = ModelContext(modelContainer)
                    await SeedDataService.seedIfNeeded(modelContext: context)
                }
        }
    }
}
