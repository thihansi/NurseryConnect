//
//  BodySide.swift
//  NurseryConnect
//
//  Purpose: Front or back orientation for body map markers.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import Foundation

// MARK: - BodySide

/// Which body silhouette is active on the incident body map.
enum BodySide: String, CaseIterable, Codable, Sendable {
    case front
    case back
}
