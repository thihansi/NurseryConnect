//
//  EYFSArea.swift
//  NurseryConnect
//
//  Purpose: EYFS learning area labels for activities and milestones.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import Foundation

// MARK: - EYFSArea

/// Statutory EYFS areas of learning used when tagging diary entries.
enum EYFSArea: String, CaseIterable, Codable, Sendable {
    case communicationLanguage
    case physicalDevelopment
    case personalSocialEmotional
    case literacy
    case mathematics
    case understandingWorld
    case expressiveArtsDesign
}
