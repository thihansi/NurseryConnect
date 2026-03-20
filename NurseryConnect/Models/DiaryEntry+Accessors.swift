//
//  DiaryEntry+Accessors.swift
//  NurseryConnect
//
//  Purpose: Typed accessors over persisted diary raw string fields.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import Foundation

// MARK: - Typed fields

extension DiaryEntry {
    /// Parsed diary entry type when the raw value is recognised.
    var entryType: DiaryEntryType? {
        DiaryEntryType(rawValue: entryTypeRaw)
    }

    /// Parsed EYFS tag when present.
    var eyfsArea: EYFSArea? {
        guard let eyfsAreaRaw else { return nil }
        return EYFSArea(rawValue: eyfsAreaRaw)
    }

    /// Parsed mood when present.
    var moodRating: MoodRating? {
        guard let moodRatingRaw else { return nil }
        return MoodRating(rawValue: moodRatingRaw)
    }

    /// Parsed meal slot when present.
    var mealSlot: MealSlot? {
        guard let mealSlotRaw else { return nil }
        return MealSlot(rawValue: mealSlotRaw)
    }

    /// Parsed meal consumption when present.
    var mealConsumption: MealConsumption? {
        guard let mealConsumptionRaw else { return nil }
        return MealConsumption(rawValue: mealConsumptionRaw)
    }

    /// Parsed drink type when present.
    var drinkType: DrinkType? {
        guard let drinkTypeRaw else { return nil }
        return DrinkType(rawValue: drinkTypeRaw)
    }

    /// Parsed nappy outcome when present.
    var nappyType: NappyChangeType? {
        guard let nappyTypeRaw else { return nil }
        return NappyChangeType(rawValue: nappyTypeRaw)
    }
}
