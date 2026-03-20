//
//  ChildAvatarView.swift
//  NurseryConnect
//
//  Purpose: Circular initials avatar tinted by the child profile colour.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import SwiftUI

// MARK: - ChildAvatarView

/// Shows two-letter initials on a coloured disk.
struct ChildAvatarView: View {
    /// Full or preferred name used for initials.
    let name: String
    /// Hex colour string from persistence.
    let colorHex: String
    /// Diameter in points.
    let size: CGFloat

    var body: some View {
        Text(name.ncInitials())
            .font(.headline.weight(.semibold))
            .foregroundStyle(Color.white)
            .frame(width: size, height: size)
            .background(Color.ncFromProfileHex(colorHex))
            .clipShape(Circle())
            .accessibilityLabel(Text("Avatar for \(name)"))
    }
}

#Preview {
    ChildAvatarView(name: "Amelia Rose", colorHex: "#5C6BC0", size: 56)
        .padding()
}
