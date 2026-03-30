//
//  MyChildrenListView.swift
//  NurseryConnect
//
//  Purpose: Assigned children grid with quick log entry point.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import SwiftData
import SwiftData
import SwiftUI

// MARK: - MyChildrenListView

/// Root list of children visible to the keyworker.
struct MyChildrenListView: View {
    @EnvironmentObject private var childListViewModel: ChildListViewModel
    @Environment(\.modelContext) private var modelContext
    @State private var isPresentingQuickLog = false
    @State private var quickLogChild: Child?
    @State private var quickLogType: DiaryEntryType?
    @State private var isPresentingAddEntry = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("My Children")
                            .font(.title2.weight(.semibold))
                            .foregroundStyle(Color.textPrimary)
                        Text(Date().ncFormattedMediumDate())
                            .font(.subheadline)
                            .foregroundStyle(Color.textSecondary)
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(
                        top: LayoutConstants.verticalPadding,
                        leading: LayoutConstants.horizontalPadding,
                        bottom: LayoutConstants.verticalPadding,
                        trailing: LayoutConstants.horizontalPadding
                    ))
                }

                Section {
                    if childListViewModel.children.isEmpty {
                        EmptyStateView(
                            icon: "person.2.slash",
                            title: "No assigned children",
                            message: "When children are assigned to you they will appear here."
                        )
                        .listRowBackground(Color.clear)
                    } else {
                        ForEach(childListViewModel.children, id: \.id) { child in
                            NavigationLink {
                                ChildDiaryView(child: child)
                            } label: {
                                ChildSummaryRow(child: child, todayCount: childListViewModel.todayEntryCount(for: child.id))
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        }
                    }
                }

                Section {
                    Text(
                        "You are viewing only the children assigned to you in compliance with UK GDPR data minimisation principles."
                    )
                    .font(.caption)
                    .foregroundStyle(Color.textSecondary)
                    .padding(.vertical, 8)
                }
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.softBackground)
            .accessibilityIdentifier("MyChildrenList")

            Button {
                isPresentingQuickLog = true
            } label: {
                Label("Quick Log", systemImage: "plus")
                    .font(.headline.weight(.semibold))
                    .padding(.horizontal, 18)
                    .padding(.vertical, 14)
                    .background(Color.primaryTeal)
                    .foregroundStyle(Color.white)
                    .clipShape(Capsule())
                    .shadow(color: Color.black.opacity(ShadowConstants.cardOpacity), radius: 6, y: 3)
            }
            .padding(.trailing, LayoutConstants.horizontalPadding)
            .padding(.bottom, 24)
            .accessibilityLabel(Text("Quick log diary entry"))
            .accessibilityIdentifier("QuickLogButton")
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            childListViewModel.refresh()
        }
        .confirmationDialog("Quick Log", isPresented: $isPresentingQuickLog, titleVisibility: .visible) {
            ForEach(childListViewModel.children, id: \.id) { child in
                Button(child.preferredName) {
                    quickLogChild = child
                    quickLogType = nil
                    isPresentingQuickLog = false
                    isPresentingAddEntry = true
                }
            }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $isPresentingAddEntry, onDismiss: {
            quickLogChild = nil
            quickLogType = nil
        }) {
            if let child = quickLogChild {
                AddDiaryEntryView(
                    modelContext: modelContext,
                    child: child,
                    initialType: quickLogType ?? .activity
                )
            }
        }
    }
}

// MARK: - ChildSummaryRow

private struct ChildSummaryRow: View {
    let child: Child
    let todayCount: Int

    var body: some View {
        HStack(spacing: 14) {
            ChildAvatarView(
                name: child.preferredName.isEmpty ? child.fullName : child.preferredName,
                colorHex: child.profileColorHex,
                size: 56
            )
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(child.preferredName)
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(Color.textPrimary)
                    if !child.allergies.isEmpty {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(Color.alertRed)
                            .accessibilityLabel(Text("Has allergies"))
                    }
                }
                Text(child.fullName)
                    .font(.subheadline)
                    .foregroundStyle(Color.textSecondary)
                HStack(spacing: 8) {
                    Text(child.roomName)
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.primaryTeal.opacity(0.12))
                        .foregroundStyle(Color.primaryTeal)
                        .clipShape(Capsule())
                    Text("Today’s entries: \(todayCount)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.textSecondary)
                }
            }
            Spacer(minLength: 0)
        }
        .padding(LayoutConstants.horizontalPadding)
        .ncCardStyle()
    }
}

#Preview {
    NavigationStack {
        MyChildrenListView()
    }
    .environmentObject(ChildListViewModel())
    .environmentObject(IncidentViewModel())
    .modelContainer(for: [Child.self, DiaryEntry.self, IncidentReport.self, BodyMapMarker.self], inMemory: true)
}
