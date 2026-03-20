//
//  DiaryEntryDraft.swift
//  NurseryConnect
//
//  Purpose: Transient payload assembled in the add-diary sheet before persistence.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import Foundation

// MARK: - DiaryEntryDraft

/// In-memory diary form values separate from SwiftData entities.
struct DiaryEntryDraft {
    /// Target child.
    var childId: UUID
    /// Selected diary category.
    var entryType: DiaryEntryType
    /// Primary narrative or notes.
    var details: String
    /// Optional learning area.
    var eyfsArea: EYFSArea?
    /// Optional mood for wellbeing.
    var moodRating: MoodRating?
    /// Meal slot when logging food.
    var mealSlot: MealSlot?
    /// Portion eaten.
    var mealConsumption: MealConsumption?
    /// Fluid intake in millilitres.
    var fluidIntakeMl: Int
    /// Drink served with the meal.
    var drinkType: DrinkType?
    /// Sleep start time.
    var sleepStart: Date?
    /// Sleep end time.
    var sleepEnd: Date?
    /// Nappy outcome.
    var nappyType: NappyChangeType?
    /// Extra notes for nappy entries.
    var nappyNotes: String
    /// Follow-up planning for milestones.
    var milestoneNextSteps: String

    /// Builds an empty draft for a child and type.
    /// - Parameters:
    ///   - childId: Child receiving the log.
    ///   - entryType: Initial type selection.
    /// - Returns: Draft with safe defaults.
    static func empty(childId: UUID, entryType: DiaryEntryType) -> DiaryEntryDraft {
        DiaryEntryDraft(
            childId: childId,
            entryType: entryType,
            details: "",
            eyfsArea: nil,
            moodRating: nil,
            mealSlot: .lunch,
            mealConsumption: .most,
            fluidIntakeMl: 0,
            drinkType: .water,
            sleepStart: Date(),
            sleepEnd: Date(),
            nappyType: .wet,
            nappyNotes: "",
            milestoneNextSteps: ""
        )
    }
}
