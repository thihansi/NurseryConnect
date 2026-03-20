//
//  View+CardStyle.swift
//  NurseryConnect
//
//  Purpose: Reusable card chrome matching the design system.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import SwiftUI

// MARK: - CardChrome

extension View {
    /// Applies standard card background, corner radius, and subtle shadow.
    /// - Returns: Modified view.
    func ncCardStyle() -> some View {
        background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: LayoutConstants.cardCornerRadius, style: .continuous))
            .shadow(
                color: Color.black.opacity(ShadowConstants.cardOpacity),
                radius: ShadowConstants.cardRadius,
                x: 0,
                y: ShadowConstants.cardYOffset
            )
    }
}
