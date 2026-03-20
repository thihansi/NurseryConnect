//
//  Constants.swift
//  NurseryConnect
//
//  Purpose: App-wide layout, timing, and user-facing string constants.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import CoreGraphics
import Foundation

// MARK: - UserDefaultsKeys

/// Keys used with `UserDefaults` for lightweight app flags.
enum UserDefaultsKeys {
    /// Set after sample data is inserted successfully.
    static let hasSeededNurseryConnectData = "hasSeededNurseryConnectData"
}

// MARK: - LaunchArguments

/// Process launch arguments read in tests or diagnostics.
enum LaunchArguments {
    /// When present, `SeedDataService` skips inserting sample rows.
    static let skipSampleSeed = "-skipSampleSeed"
}

// MARK: - AppConstants

/// Fixed keyworker identity for this offline MVP build.
enum AppConstants {
    /// Display name for the assumed signed-in practitioner.
    static let currentKeyworkerName = "Sarah Mitchell"
}

// MARK: - LayoutConstants

/// Reusable layout metrics for cards and tap targets.
enum LayoutConstants {
    /// Standard horizontal padding for screen edges.
    static let horizontalPadding: CGFloat = 16
    /// Standard vertical padding between stacked sections.
    static let verticalPadding: CGFloat = 8
    /// Corner radius for elevated cards.
    static let cardCornerRadius: CGFloat = 12
    /// Minimum interactive control dimension (HIG).
    static let minimumTapTarget: CGFloat = 44
    /// Hours after which a draft incident triggers a regulatory banner.
    static let draftIncidentStaleHours: TimeInterval = 1
}

// MARK: - ShadowConstants

/// Shadow parameters for card elevation.
enum ShadowConstants {
    static let cardRadius: CGFloat = 4
    static let cardYOffset: CGFloat = 2
    static let cardOpacity: Double = 0.08
}
