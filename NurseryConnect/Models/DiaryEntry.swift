//
//  DiaryEntry.swift
//  NurseryConnect
//
//  Purpose: SwiftData model for timestamped diary rows with type-specific fields.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import Foundation
import SwiftData

// MARK: - DiaryEntry

/// A single diary observation for one child at an automatic timestamp.
@Model
final class DiaryEntry {
    /// Primary key.
    var id: UUID
    /// Child this entry belongs to.
    var childId: UUID
    /// Auto-captured time of logging (EYFS compliance).
    var timestamp: Date
    /// Persisted `DiaryEntryType` raw value.
    var entryTypeRaw: String
    /// Free-text summary or primary notes.
    var details: String
    /// Optional EYFS area raw value.
    var eyfsAreaRaw: String?
    /// Optional mood raw value.
    var moodRatingRaw: String?
    /// Meal slot when `entryType` is meal.
    var mealSlotRaw: String?
    /// Meal consumption when `entryType` is meal.
    var mealConsumptionRaw: String?
    /// Fluid intake millilitres when `entryType` is meal.
    var fluidIntakeMl: Int?
    /// Drink type raw when `entryType` is meal.
    var drinkTypeRaw: String?
    /// Sleep interval start when `entryType` is sleep.
    var sleepStart: Date?
    /// Sleep interval end when `entryType` is sleep.
    var sleepEnd: Date?
    /// Nappy outcome raw when `entryType` is nappy.
    var nappyTypeRaw: String?
    /// Next steps when `entryType` is milestone.
    var milestoneNextSteps: String?

    /// Creates a diary entry with optional structured fields.
    /// - Parameters:
    ///   - id: Identifier.
    ///   - childId: Owning child.
    ///   - timestamp: Capture time.
    ///   - entryTypeRaw: Type string.
    ///   - details: Main text.
    ///   - eyfsAreaRaw: Optional EYFS tag.
    ///   - moodRatingRaw: Optional mood.
    ///   - mealSlotRaw: Meal slot.
    ///   - mealConsumptionRaw: Consumption.
    ///   - fluidIntakeMl: Fluids ml.
    ///   - drinkTypeRaw: Drink type.
    ///   - sleepStart: Sleep start.
    ///   - sleepEnd: Sleep end.
    ///   - nappyTypeRaw: Nappy type.
    ///   - milestoneNextSteps: Milestone follow-up.
    init(
        id: UUID,
        childId: UUID,
        timestamp: Date,
        entryTypeRaw: String,
        details: String,
        eyfsAreaRaw: String? = nil,
        moodRatingRaw: String? = nil,
        mealSlotRaw: String? = nil,
        mealConsumptionRaw: String? = nil,
        fluidIntakeMl: Int? = nil,
        drinkTypeRaw: String? = nil,
        sleepStart: Date? = nil,
        sleepEnd: Date? = nil,
        nappyTypeRaw: String? = nil,
        milestoneNextSteps: String? = nil
    ) {
        self.id = id
        self.childId = childId
        self.timestamp = timestamp
        self.entryTypeRaw = entryTypeRaw
        self.details = details
        self.eyfsAreaRaw = eyfsAreaRaw
        self.moodRatingRaw = moodRatingRaw
        self.mealSlotRaw = mealSlotRaw
        self.mealConsumptionRaw = mealConsumptionRaw
        self.fluidIntakeMl = fluidIntakeMl
        self.drinkTypeRaw = drinkTypeRaw
        self.sleepStart = sleepStart
        self.sleepEnd = sleepEnd
        self.nappyTypeRaw = nappyTypeRaw
        self.milestoneNextSteps = milestoneNextSteps
    }
}
