//
//  EnumDisplayStrings.swift
//  NurseryConnect
//
//  Purpose: Human-readable labels for persisted enum raw values in the UI.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import Foundation

// MARK: - DiaryEntryType

extension DiaryEntryType {
    /// Short title for lists and pickers.
    var displayTitle: String {
        switch self {
        case .activity: return "Activity"
        case .sleep: return "Sleep"
        case .meal: return "Meal"
        case .nappy: return "Nappy"
        case .wellbeing: return "Wellbeing"
        case .milestone: return "Milestone"
        case .departure: return "Departure"
        case .arrival: return "Arrival"
        }
    }
}

// MARK: - EYFSArea

extension EYFSArea {
    /// Readable EYFS area name.
    var displayTitle: String {
        switch self {
        case .communicationLanguage: return "Communication & Language"
        case .physicalDevelopment: return "Physical Development"
        case .personalSocialEmotional: return "PSED"
        case .literacy: return "Literacy"
        case .mathematics: return "Mathematics"
        case .understandingWorld: return "Understanding the World"
        case .expressiveArtsDesign: return "Expressive Arts & Design"
        }
    }
}

// MARK: - MoodRating

extension MoodRating {
    /// Emoji paired with the mood for quick scanning.
    var displayEmoji: String {
        switch self {
        case .happy: return "😊"
        case .settled: return "🙂"
        case .unsettled: return "😕"
        case .upset: return "😢"
        case .unwell: return "🤒"
        }
    }

    /// Accessible text alongside emoji.
    var displayTitle: String {
        switch self {
        case .happy: return "Happy"
        case .settled: return "Settled"
        case .unsettled: return "Unsettled"
        case .upset: return "Upset"
        case .unwell: return "Unwell"
        }
    }
}

// MARK: - MealSlot

extension MealSlot {
    /// Meal slot label.
    var displayTitle: String {
        switch self {
        case .breakfast: return "Breakfast"
        case .morningSnack: return "Morning snack"
        case .lunch: return "Lunch"
        case .afternoonSnack: return "Afternoon snack"
        }
    }
}

// MARK: - MealConsumption

extension MealConsumption {
    /// Portion label.
    var displayTitle: String {
        switch self {
        case .all: return "All"
        case .most: return "Most"
        case .half: return "Half"
        case .little: return "Little"
        case .none: return "None"
        case .refused: return "Refused"
        }
    }
}

// MARK: - DrinkType

extension DrinkType {
    /// Drink label.
    var displayTitle: String {
        switch self {
        case .water: return "Water"
        case .milk: return "Milk"
        case .juice: return "Juice"
        case .oatMilk: return "Oat milk"
        case .other: return "Other"
        }
    }
}

// MARK: - NappyChangeType

extension NappyChangeType {
    /// Nappy outcome label.
    var displayTitle: String {
        switch self {
        case .wet: return "Wet"
        case .dirty: return "Dirty"
        case .both: return "Both"
        case .none: return "Clean / dry"
        }
    }
}

// MARK: - IncidentCategory

extension IncidentCategory {
    /// Short title for badges.
    var displayTitle: String {
        switch self {
        case .accidentMinor: return "Minor accident"
        case .accidentFirstAid: return "First aid"
        case .safeguardingConcern: return "Safeguarding"
        case .nearMiss: return "Near miss"
        case .allergicReaction: return "Allergic reaction"
        case .medicalIncident: return "Medical"
        }
    }

    /// Longer guidance for the picker.
    var displayDescription: String {
        switch self {
        case .accidentMinor:
            return "Small injury not requiring escalation beyond room first aid."
        case .accidentFirstAid:
            return "Injury needing recorded first aid and close monitoring."
        case .safeguardingConcern:
            return "Any concern that may affect child welfare; escalate immediately."
        case .nearMiss:
            return "Event that could have caused harm but did not."
        case .allergicReaction:
            return "Suspected or confirmed allergic response."
        case .medicalIncident:
            return "Illness or medical episode requiring documentation."
        }
    }
}

// MARK: - IncidentStatus

extension IncidentStatus {
    /// Status chip label.
    var displayTitle: String {
        switch self {
        case .draft: return "Draft"
        case .submittedForReview: return "Submitted"
        case .parentNotified: return "Parent notified"
        case .acknowledged: return "Acknowledged"
        }
    }
}

// MARK: - BodySide

extension BodySide {
    /// Side label for the body map toggle.
    var displayTitle: String {
        switch self {
        case .front: return "Front"
        case .back: return "Back"
        }
    }
}
