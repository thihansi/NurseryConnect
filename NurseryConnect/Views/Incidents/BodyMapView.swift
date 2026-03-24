//
//  BodyMapView.swift
//  NurseryConnect
//
//  Purpose: Tap-to-mark front/back silhouettes for incident documentation.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import SwiftUI

// MARK: - BodyMapView

/// Interactive silhouette with normalised marker coordinates.
struct BodyMapView: View {
    /// Active silhouette side.
    @Binding var side: BodySide
    /// All markers; filtered visually by side.
    let markers: [BodyMapMarkerDraft]
    /// Delivers normalised tap coordinates for the active side.
    let onTapNormalized: (CGPoint) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Picker("Side", selection: $side) {
                ForEach(BodySide.allCases, id: \.self) { value in
                    Text(value.displayTitle).tag(value)
                }
            }
            .pickerStyle(.segmented)

            GeometryReader { proxy in
                ZStack {
                    BodySilhouetteShape(side: side)
                        .stroke(Color.textSecondary.opacity(0.6), lineWidth: 2)
                        .background(
                            BodySilhouetteShape(side: side)
                                .fill(Color.primaryTeal.opacity(0.08))
                        )
                        .contentShape(BodySilhouetteShape(side: side))

                    ForEach(markers.filter { $0.side == side }) { marker in
                        Text("\(marker.displayIndex)")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(Color.white)
                            .frame(width: 22, height: 22)
                            .background(Color.alertRed)
                            .clipShape(Circle())
                            .position(
                                x: CGFloat(marker.xPosition) * proxy.size.width,
                                y: CGFloat(marker.yPosition) * proxy.size.height
                            )
                            .accessibilityHidden(true)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onEnded { value in
                            let point = value.location
                            guard proxy.size.width > 0, proxy.size.height > 0 else {
                                return
                            }
                            let normalized = CGPoint(
                                x: point.x / proxy.size.width,
                                y: point.y / proxy.size.height
                            )
                            onTapNormalized(normalized)
                        }
                )
            }
            .aspectRatio(0.55, contentMode: .fit)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(Text("Body map, \(side.displayTitle)"))
            .accessibilityHint(Text("Tap on the outline to place a marker."))
        }
    }
}

// MARK: - BodySilhouetteShape

/// Simple front/back human outline using quadratic curves only.
struct BodySilhouetteShape: Shape {
    /// Which outline to draw.
    var side: BodySide

    /// Builds the path in the given rectangle.
    func path(in rect: CGRect) -> Path {
        switch side {
        case .front:
            return frontPath(in: rect)
        case .back:
            return backPath(in: rect)
        }
    }

    private func frontPath(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let head = CGRect(x: w * 0.38, y: h * 0.02, width: w * 0.24, height: h * 0.14)
        path.addEllipse(in: head)
        path.move(to: CGPoint(x: w * 0.5, y: h * 0.16))
        path.addLine(to: CGPoint(x: w * 0.34, y: h * 0.26))
        path.addQuadCurve(
            to: CGPoint(x: w * 0.3, y: h * 0.42),
            control: CGPoint(x: w * 0.28, y: h * 0.32)
        )
        path.addLine(to: CGPoint(x: w * 0.32, y: h * 0.62))
        path.addQuadCurve(
            to: CGPoint(x: w * 0.4, y: h * 0.9),
            control: CGPoint(x: w * 0.3, y: h * 0.78)
        )
        path.addLine(to: CGPoint(x: w * 0.46, y: h * 0.96))
        path.addLine(to: CGPoint(x: w * 0.54, y: h * 0.96))
        path.addLine(to: CGPoint(x: w * 0.6, y: h * 0.9))
        path.addQuadCurve(
            to: CGPoint(x: w * 0.68, y: h * 0.62),
            control: CGPoint(x: w * 0.7, y: h * 0.78)
        )
        path.addLine(to: CGPoint(x: w * 0.7, y: h * 0.42))
        path.addQuadCurve(
            to: CGPoint(x: w * 0.66, y: h * 0.26),
            control: CGPoint(x: w * 0.72, y: h * 0.32)
        )
        path.closeSubpath()
        return path
    }

    private func backPath(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let head = CGRect(x: w * 0.38, y: h * 0.02, width: w * 0.24, height: h * 0.14)
        path.addEllipse(in: head)
        path.move(to: CGPoint(x: w * 0.5, y: h * 0.16))
        path.addLine(to: CGPoint(x: w * 0.33, y: h * 0.26))
        path.addQuadCurve(
            to: CGPoint(x: w * 0.3, y: h * 0.45),
            control: CGPoint(x: w * 0.27, y: h * 0.34)
        )
        path.addLine(to: CGPoint(x: w * 0.33, y: h * 0.64))
        path.addQuadCurve(
            to: CGPoint(x: w * 0.42, y: h * 0.92),
            control: CGPoint(x: w * 0.32, y: h * 0.8)
        )
        path.addLine(to: CGPoint(x: w * 0.58, y: h * 0.92))
        path.addQuadCurve(
            to: CGPoint(x: w * 0.67, y: h * 0.64),
            control: CGPoint(x: w * 0.68, y: h * 0.8)
        )
        path.addLine(to: CGPoint(x: w * 0.7, y: h * 0.45))
        path.addQuadCurve(
            to: CGPoint(x: w * 0.67, y: h * 0.26),
            control: CGPoint(x: w * 0.73, y: h * 0.34)
        )
        path.closeSubpath()
        return path
    }
}

#Preview {
    struct PreviewHolder: View {
        @State private var side = BodySide.front
        @State private var markers: [BodyMapMarkerDraft] = []

        var body: some View {
            BodyMapView(side: $side, markers: markers) { point in
                let draft = BodyMapMarkerDraft(
                    id: UUID(),
                    xPosition: Double(point.x),
                    yPosition: Double(point.y),
                    side: side,
                    note: "",
                    displayIndex: markers.count + 1
                )
                markers.append(draft)
            }
            .padding()
        }
    }
    return PreviewHolder()
}
