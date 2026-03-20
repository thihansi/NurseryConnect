//
//  ChildListViewModel.swift
//  NurseryConnect
//
//  Purpose: Loads assigned children and counts today’s diary rows per child.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import Foundation
import SwiftData
import SwiftUI

// MARK: - ChildListViewModel

/// Supplies the My Children list with sorted rows and badge counts.
@MainActor
final class ChildListViewModel: ObservableObject {
    /// Latest children fetched from SwiftData.
    @Published private(set) var children: [Child] = []
    /// Bound persistence context.
    private var modelContext: ModelContext?

    /// Creates an empty view model awaiting context binding.
    init() {}

    /// Injects the active `ModelContext` once the SwiftUI environment is ready.
    /// - Parameter context: Shared model context.
    func bind(modelContext context: ModelContext) {
        if modelContext == nil {
            modelContext = context
            refresh()
        }
    }

    /// Reloads children and sorts by preferred name.
    func refresh() {
        guard let modelContext else {
            return
        }
        let descriptor = FetchDescriptor<Child>(
            sortBy: [SortDescriptor(\Child.preferredName, order: .forward)]
        )
        do {
            children = try modelContext.fetch(descriptor)
        } catch {
            children = []
        }
    }

    /// Counts diary entries for a child on the given calendar day.
    /// - Parameters:
    ///   - childId: Child identifier.
    ///   - day: Day to evaluate.
    ///   - calendar: Calendar boundaries.
    /// - Returns: Number of matching entries.
    func todayEntryCount(for childId: UUID, on day: Date = Date(), calendar: Calendar = .current) -> Int {
        guard let modelContext else {
            return 0
        }
        let start = calendar.startOfDay(for: day)
        guard let end = calendar.date(byAdding: .day, value: 1, to: start) else {
            return 0
        }
        let childUUID = childId
        let predicate = #Predicate<DiaryEntry> { entry in
            entry.childId == childUUID && entry.timestamp >= start && entry.timestamp < end
        }
        var descriptor = FetchDescriptor<DiaryEntry>(predicate: predicate)
        descriptor.fetchLimit = 200
        do {
            let rows = try modelContext.fetch(descriptor)
            return rows.count
        } catch {
            return 0
        }
    }
}
