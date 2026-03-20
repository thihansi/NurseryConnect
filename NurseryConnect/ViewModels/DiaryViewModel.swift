//
//  DiaryViewModel.swift
//  NurseryConnect
//
//  Purpose: Reads and writes diary entries for a single child with validation.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import Combine
import Foundation
import SwiftData

// MARK: - DiaryViewModel

/// Coordinates diary timeline data and persistence for one child.
@MainActor
final class DiaryViewModel: ObservableObject {
    /// Child identifier for queries.
    private let childId: UUID
    /// SwiftData access.
    private var modelContext: ModelContext?

    /// Creates a diary view model for a specific child.
    /// - Parameters:
    ///   - childId: Target child.
    ///   - modelContext: Optional context; bind later if nil.
    init(childId: UUID, modelContext: ModelContext? = nil) {
        self.childId = childId
        self.modelContext = modelContext
    }

    /// Binds or replaces the model context.
    /// - Parameter context: Active context.
    func bind(modelContext context: ModelContext) {
        modelContext = context
    }

    /// Fetches diary entries for the child on a calendar day, oldest first.
    /// - Parameters:
    ///   - day: Reference day.
    ///   - calendar: Calendar boundary rules.
    /// - Returns: Ordered entries.
    func fetchEntriesForChild(on day: Date = Date(), calendar: Calendar = .current) -> [DiaryEntry] {
        guard let modelContext else {
            return []
        }
        let start = calendar.startOfDay(for: day)
        guard let end = calendar.date(byAdding: .day, value: 1, to: start) else {
            return []
        }
        let childUUID = childId
        let predicate = #Predicate<DiaryEntry> { entry in
            entry.childId == childUUID && entry.timestamp >= start && entry.timestamp < end
        }
        var descriptor = FetchDescriptor<DiaryEntry>(
            predicate: predicate,
            sortBy: [SortDescriptor(\DiaryEntry.timestamp, order: .forward)]
        )
        descriptor.fetchLimit = 500
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            return []
        }
    }

    /// Validates a draft without mutating persistence.
    /// - Parameter draft: Proposed entry.
    /// - Returns: Field errors keyed by logical field name.
    func validateEntry(_ draft: DiaryEntryDraft) -> [String: String] {
        DiaryEntryValidation.validationMessages(for: draft)
    }

    /// Persists a validated diary entry with an automatic timestamp.
    /// - Parameter draft: Source draft.
    /// - Returns: Whether save succeeded.
    @discardableResult
    func addEntry(_ draft: DiaryEntryDraft) -> Bool {
        let issues = validateEntry(draft)
        if !issues.isEmpty {
            return false
        }
        guard let modelContext else {
            return false
        }
        let capturedAt = Date()
        let combinedNappyDetails: String
        if draft.entryType == .nappy {
            let notes = draft.nappyNotes.trimmingCharacters(in: .whitespacesAndNewlines)
            combinedNappyDetails = notes
        } else {
            combinedNappyDetails = draft.details.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        let detailsText: String
        switch draft.entryType {
        case .nappy:
            detailsText = combinedNappyDetails
        case .sleep:
            if let start = draft.sleepStart, let end = draft.sleepEnd, end > start {
                let minutes = Int(end.timeIntervalSince(start) / 60)
                let hours = minutes / 60
                let remainder = minutes % 60
                detailsText = "Slept \(hours)h \(remainder)m"
            } else {
                detailsText = combinedNappyDetails
            }
        default:
            detailsText = draft.details.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        let entry = DiaryEntry(
            id: UUID(),
            childId: draft.childId,
            timestamp: capturedAt,
            entryTypeRaw: draft.entryType.rawValue,
            details: detailsText,
            eyfsAreaRaw: draft.eyfsArea?.rawValue,
            moodRatingRaw: draft.moodRating?.rawValue,
            mealSlotRaw: draft.mealSlot?.rawValue,
            mealConsumptionRaw: draft.mealConsumption?.rawValue,
            fluidIntakeMl: draft.entryType == .meal ? draft.fluidIntakeMl : nil,
            drinkTypeRaw: draft.drinkType?.rawValue,
            sleepStart: draft.entryType == .sleep ? draft.sleepStart : nil,
            sleepEnd: draft.entryType == .sleep ? draft.sleepEnd : nil,
            nappyTypeRaw: draft.nappyType?.rawValue,
            milestoneNextSteps: draft.entryType == .milestone ? draft.milestoneNextSteps : nil
        )
        modelContext.insert(entry)
        do {
            try modelContext.save()
            return true
        } catch {
            modelContext.delete(entry)
            return false
        }
    }
}
