//
//  IncidentReport.swift
//  NurseryConnect
//
//  Purpose: SwiftData model for incident workflow with related body map markers.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import Foundation
import SwiftData

// MARK: - IncidentReport

/// Formal incident record including denormalised child display name.
@Model
final class IncidentReport {
    /// Primary key.
    var id: UUID
    /// Linked child identifier.
    var childId: UUID
    /// Cached child name for list/detail display.
    var childName: String
    /// Reporting practitioner (fixed for this MVP build).
    var keyworkerName: String
    /// Immutable capture time for the report shell.
    var reportedAt: Date
    /// Persisted `IncidentCategory` raw value.
    var incidentCategoryRaw: String
    /// Free-text location within the setting (e.g. garden, lunch room).
    var incidentLocation: String
    /// Narrative description of what happened.
    var incidentDescription: String
    /// Actions taken immediately after the event.
    var immediateActionTaken: String
    /// Witness names as entered by the reporter.
    var witnesses: [String]
    /// Workflow status raw value.
    var statusRaw: String
    /// When the parent was notified, if applicable.
    var parentNotifiedAt: Date?
    /// Tap markers drawn on the body map.
    @Relationship(deleteRule: .cascade, inverse: \BodyMapMarker.incidentReport)
    var markers: [BodyMapMarker]

    /// Creates an incident report container.
    /// - Parameters:
    ///   - id: UUID.
    ///   - childId: Child id.
    ///   - childName: Display name snapshot.
    ///   - keyworkerName: Reporter name.
    ///   - reportedAt: Timestamp.
    ///   - incidentCategoryRaw: Category string.
    ///   - incidentLocation: Where it happened.
    ///   - incidentDescription: What happened.
    ///   - immediateActionTaken: Immediate response.
    ///   - witnesses: Witness list.
    ///   - statusRaw: Status string.
    ///   - parentNotifiedAt: Optional notification time.
    ///   - markers: Body markers.
    init(
        id: UUID,
        childId: UUID,
        childName: String,
        keyworkerName: String,
        reportedAt: Date,
        incidentCategoryRaw: String,
        incidentLocation: String,
        incidentDescription: String,
        immediateActionTaken: String,
        witnesses: [String],
        statusRaw: String,
        parentNotifiedAt: Date? = nil,
        markers: [BodyMapMarker] = []
    ) {
        self.id = id
        self.childId = childId
        self.childName = childName
        self.keyworkerName = keyworkerName
        self.reportedAt = reportedAt
        self.incidentCategoryRaw = incidentCategoryRaw
        self.incidentLocation = incidentLocation
        self.incidentDescription = incidentDescription
        self.immediateActionTaken = immediateActionTaken
        self.witnesses = witnesses
        self.statusRaw = statusRaw
        self.parentNotifiedAt = parentNotifiedAt
        self.markers = markers
    }
}
