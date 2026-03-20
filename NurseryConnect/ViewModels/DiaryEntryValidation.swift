//
//  DiaryEntryValidation.swift
//  NurseryConnect
//
//  Purpose: Field-level validation rules for diary drafts by entry type.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import Foundation

// MARK: - DiaryEntryValidation

/// Validates `DiaryEntryDraft` values before persistence.
enum DiaryEntryValidation {
    /// Runs type-aware checks on the draft.
    /// - Parameter draft: User-authored draft.
    /// - Returns: Map of field keys to error copy.
    static func validationMessages(for draft: DiaryEntryDraft) -> [String: String] {
        var messages: [String: String] = [:]
        let trimmedDetails = draft.details.trimmingCharacters(in: .whitespacesAndNewlines)
        switch draft.entryType {
        case .activity:
            if trimmedDetails.isEmpty {
                messages["details"] = "Please describe the activity."
            }
            if draft.eyfsArea == nil {
                messages["eyfsArea"] = "Select an EYFS area."
            }
        case .sleep:
            if let start = draft.sleepStart, let end = draft.sleepEnd, end <= start {
                messages["sleepEnd"] = "End time must be after start time."
            }
            if draft.sleepStart == nil || draft.sleepEnd == nil {
                messages["sleep"] = "Choose both start and end times."
            }
        case .meal:
            if draft.mealSlot == nil {
                messages["mealSlot"] = "Select a meal slot."
            }
            if draft.mealConsumption == nil {
                messages["mealConsumption"] = "Select how much was eaten."
            }
            if draft.drinkType == nil {
                messages["drinkType"] = "Select a drink type."
            }
            if draft.fluidIntakeMl < 0 {
                messages["fluid"] = "Fluid intake cannot be negative."
            }
        case .nappy:
            if draft.nappyType == nil {
                messages["nappyType"] = "Select a nappy outcome."
            }
        case .wellbeing:
            if draft.moodRating == nil {
                messages["mood"] = "Select how the child seemed."
            }
            if trimmedDetails.isEmpty {
                messages["details"] = "Add a short observation."
            }
        case .milestone:
            if draft.eyfsArea == nil {
                messages["eyfsArea"] = "Select an EYFS area."
            }
            if trimmedDetails.isEmpty {
                messages["details"] = "Describe the milestone."
            }
            let next = draft.milestoneNextSteps.trimmingCharacters(in: .whitespacesAndNewlines)
            if next.isEmpty {
                messages["nextSteps"] = "Add suggested next steps."
            }
        case .departure, .arrival:
            if trimmedDetails.isEmpty {
                messages["details"] = "Add brief handover notes."
            }
        }
        return messages
    }
}
