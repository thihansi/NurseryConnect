//
//  RootTabView.swift
//  NurseryConnect
//
//  Purpose: Tab shell with regulatory draft banner and shared view models.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import SwiftData
import SwiftUI

// MARK: - RootTabView

/// Application root containing the two primary feature tabs.
struct RootTabView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var childListViewModel = ChildListViewModel()
    @StateObject private var incidentViewModel = IncidentViewModel()

    var body: some View {
        VStack(spacing: 0) {
            if incidentViewModel.showDraftStaleBanner {
                draftBanner
            }
            TabView {
                NavigationStack {
                    MyChildrenListView()
                }
                .tabItem {
                    Label("My Children", systemImage: "person.2.fill")
                }

                NavigationStack {
                    IncidentListView()
                }
                .tabItem {
                    Label("Incidents", systemImage: "exclamationmark.triangle.fill")
                }
                .badge(draftBadgeValue)
            }
        }
        .tint(Color.primaryTeal)
        .environmentObject(childListViewModel)
        .environmentObject(incidentViewModel)
        .onAppear {
            childListViewModel.bind(modelContext: modelContext)
            incidentViewModel.bind(modelContext: modelContext)
        }
        .onChange(of: scenePhase) { _, newPhase in
            guard newPhase == .active else {
                return
            }
            childListViewModel.refresh()
            incidentViewModel.refresh()
            incidentViewModel.updateStaleDraftBanner()
        }
    }

    private var draftBadgeValue: Int {
        let count = incidentViewModel.draftBadgeCount()
        return count > 0 ? count : 0
    }

    private var draftBanner: some View {
        HStack(alignment: .center, spacing: 10) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(Color.warningAmber)
                .accessibilityHidden(true)
            Text(
                "You have an unsubmitted incident report. EYFS requires same-day parent notification."
            )
            .font(.caption.weight(.semibold))
            .foregroundStyle(Color.textPrimary)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, LayoutConstants.horizontalPadding)
        .padding(.vertical, LayoutConstants.verticalPadding)
        .background(Color.warningAmber.opacity(0.18))
    }
}

#Preview {
    RootTabView()
        .modelContainer(for: [Child.self, DiaryEntry.self, IncidentReport.self, BodyMapMarker.self], inMemory: true)
}
