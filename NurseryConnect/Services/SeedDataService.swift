//
//  SeedDataService.swift
//  NurseryConnect
//
//  Purpose: Inserts assignment sample data once per install unless skipped.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import Foundation
import SwiftData

// MARK: - SeedDataService

/// Populates realistic children, diary rows, and one incident for demos.
enum SeedDataService {
    // MARK: Seed identifiers

    /// Amelia's stable id for diary foreign keys.
    static let ameliaChildId = UUID(uuidString: "E0010000-0000-4000-8000-000000000001")
    /// Oliver's stable id.
    static let oliverChildId = UUID(uuidString: "E0010000-0000-4000-8000-000000000002")
    /// Isla's stable id.
    static let islaChildId = UUID(uuidString: "E0010000-0000-4000-8000-000000000003")

    /// Inserts bundled sample rows when the flag is clear and seeding is allowed.
    /// - Parameter modelContext: Active SwiftData context.
    /// - Returns: Nothing; errors are swallowed after rollback attempt.
    @MainActor
    static func seedIfNeeded(modelContext: ModelContext) async {
        let args = ProcessInfo.processInfo.arguments
        if args.contains(LaunchArguments.skipSampleSeed) {
            return
        }
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: UserDefaultsKeys.hasSeededNurseryConnectData) {
            return
        }
        guard
            let ameliaId = ameliaChildId,
            let oliverId = oliverChildId,
            let islaId = islaChildId
        else {
            return
        }
        let calendar = Calendar.current
        let ameliaDOB = calendar.date(from: DateComponents(year: 2022, month: 3, day: 14)) ?? Date()
        let oliverDOB = calendar.date(from: DateComponents(year: 2021, month: 11, day: 5)) ?? Date()
        let islaDOB = calendar.date(from: DateComponents(year: 2023, month: 1, day: 22)) ?? Date()
        let amelia = Child(
            id: ameliaId,
            fullName: "Amelia Rose Thompson",
            preferredName: "Amelia",
            dateOfBirth: ameliaDOB,
            roomName: "Sunshine Room",
            profileColorHex: "#5C6BC0",
            allergies: ["Peanuts", "Tree Nuts"],
            dietaryNotes: "Nut-free diet strictly enforced. EpiPen in manager's office.",
            hasPhotographyConsent: true
        )
        let oliver = Child(
            id: oliverId,
            fullName: "Oliver James Patel",
            preferredName: "Oliver",
            dateOfBirth: oliverDOB,
            roomName: "Rainbow Room",
            profileColorHex: "#2A7F7F",
            allergies: [],
            dietaryNotes: "Vegetarian",
            hasPhotographyConsent: true
        )
        let isla = Child(
            id: islaId,
            fullName: "Isla Mae Browne",
            preferredName: "Isla",
            dateOfBirth: islaDOB,
            roomName: "Sunshine Room",
            profileColorHex: "#EC407A",
            allergies: ["Dairy"],
            dietaryNotes: "Dairy-free. Full-fat oat milk provided by parent.",
            hasPhotographyConsent: false
        )
        let now = Date()
        let activityEntry = DiaryEntry(
            id: UUID(),
            childId: ameliaId,
            timestamp: now,
            entryTypeRaw: DiaryEntryType.activity.rawValue,
            details: "Explored water play and practiced pouring with peers.",
            eyfsAreaRaw: EYFSArea.expressiveArtsDesign.rawValue,
            moodRatingRaw: nil,
            mealSlotRaw: nil,
            mealConsumptionRaw: nil,
            fluidIntakeMl: nil,
            drinkTypeRaw: nil,
            sleepStart: nil,
            sleepEnd: nil,
            nappyTypeRaw: nil,
            milestoneNextSteps: nil
        )
        let mealEntry = DiaryEntry(
            id: UUID(),
            childId: ameliaId,
            timestamp: now,
            entryTypeRaw: DiaryEntryType.meal.rawValue,
            details: "Lunch: pasta and vegetables. Monitored for allergens.",
            eyfsAreaRaw: nil,
            moodRatingRaw: nil,
            mealSlotRaw: MealSlot.lunch.rawValue,
            mealConsumptionRaw: MealConsumption.most.rawValue,
            fluidIntakeMl: 120,
            drinkTypeRaw: DrinkType.water.rawValue,
            sleepStart: nil,
            sleepEnd: nil,
            nappyTypeRaw: nil,
            milestoneNextSteps: nil
        )
        let incident = IncidentReport(
            id: UUID(),
            childId: oliverId,
            childName: oliver.fullName,
            keyworkerName: AppConstants.currentKeyworkerName,
            reportedAt: now,
            incidentCategoryRaw: IncidentCategory.accidentMinor.rawValue,
            incidentLocation: "Garden area",
            incidentDescription: "Minor trip on uneven paving; grazed knee cleaned and plaster applied.",
            immediateActionTaken: "First aid administered, comfort given, play supervised closely afterwards.",
            witnesses: ["Alex Reed"],
            statusRaw: IncidentStatus.submittedForReview.rawValue,
            parentNotifiedAt: nil,
            markers: []
        )
        modelContext.insert(amelia)
        modelContext.insert(oliver)
        modelContext.insert(isla)
        modelContext.insert(activityEntry)
        modelContext.insert(mealEntry)
        modelContext.insert(incident)
        do {
            try modelContext.save()
            defaults.set(true, forKey: UserDefaultsKeys.hasSeededNurseryConnectData)
        } catch {
            modelContext.rollback()
        }
    }
}
