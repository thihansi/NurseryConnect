//
//  Child.swift
//  NurseryConnect
//
//  Purpose: SwiftData model for a child assigned to the keyworker.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import Foundation
import SwiftData

// MARK: - Child

/// A child profile visible to the signed-in keyworker (implicit assignment).
@Model
final class Child {
    /// Stable identifier for the child record.
    var id: UUID
    /// Legal full name.
    var fullName: String
    /// Name used day-to-day in the room.
    var preferredName: String
    /// Date of birth for age-appropriate care planning.
    var dateOfBirth: Date
    /// Nursery room label.
    var roomName: String
    /// Hex colour for avatar backgrounds (e.g. "#2A7F7F").
    var profileColorHex: String
    /// Known allergens; empty when none recorded.
    var allergies: [String]
    /// Dietary notes including parental instructions.
    var dietaryNotes: String
    /// Whether photo/video consent is on file.
    var hasPhotographyConsent: Bool

    /// Creates a persisted child profile.
    /// - Parameters:
    ///   - id: Primary key.
    ///   - fullName: Legal name.
    ///   - preferredName: Display name.
    ///   - dateOfBirth: DOB.
    ///   - roomName: Room assignment.
    ///   - profileColorHex: Avatar tint hex.
    ///   - allergies: Allergen list.
    ///   - dietaryNotes: Diet notes.
    ///   - hasPhotographyConsent: Consent flag.
    init(
        id: UUID,
        fullName: String,
        preferredName: String,
        dateOfBirth: Date,
        roomName: String,
        profileColorHex: String,
        allergies: [String],
        dietaryNotes: String,
        hasPhotographyConsent: Bool
    ) {
        self.id = id
        self.fullName = fullName
        self.preferredName = preferredName
        self.dateOfBirth = dateOfBirth
        self.roomName = roomName
        self.profileColorHex = profileColorHex
        self.allergies = allergies
        self.dietaryNotes = dietaryNotes
        self.hasPhotographyConsent = hasPhotographyConsent
    }
}
