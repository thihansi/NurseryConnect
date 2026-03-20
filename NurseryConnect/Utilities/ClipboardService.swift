//
//  ClipboardService.swift
//  NurseryConnect
//
//  Purpose: Copies plain text to the system pasteboard for incident export.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import UIKit

// MARK: - ClipboardService

/// Thin UIKit wrapper so views do not touch `UIPasteboard` directly.
enum ClipboardService {
    /// Places UTF-8 text on the general pasteboard.
    /// - Parameter text: Full export body.
    static func copyToPasteboard(text: String) {
        UIPasteboard.general.string = text
    }
}
