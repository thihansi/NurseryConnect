//
//  ChildDiaryView.swift
//  NurseryConnect
//
//  Purpose: Diary timeline and read-only profile for one child.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import SwiftUI

// MARK: - ChildDiaryView

/// Tabbed experience for today’s diary and static profile data.
struct ChildDiaryView: View {
    let child: Child
    @Environment(\.modelContext) private var modelContext
    @StateObject private var diaryViewModel: DiaryViewModel
    @State private var selectedSegment = 0
    @State private var entries: [DiaryEntry] = []
    @State private var isPresentingAddEntry = false

    init(child: Child) {
        self.child = child
        _diaryViewModel = StateObject(wrappedValue: DiaryViewModel(childId: child.id))
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            Picker("Section", selection: $selectedSegment) {
                Text("Today’s Diary").tag(0)
                Text("Child Profile").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, LayoutConstants.horizontalPadding)
            .padding(.vertical, LayoutConstants.verticalPadding)

            if selectedSegment == 0 {
                diarySection
            } else {
                profileSection
            }
        }
        .background(Color.softBackground)
        .navigationTitle(child.preferredName)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            diaryViewModel.bind(modelContext: modelContext)
            reloadEntries()
        }
        .sheet(isPresented: $isPresentingAddEntry, onDismiss: {
            reloadEntries()
        }) {
            AddDiaryEntryView(
                modelContext: modelContext,
                child: child,
                initialType: .activity
            )
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            if !child.allergies.isEmpty {
                AllergyWarningBanner(allergies: child.allergies)
            }
            if !child.hasPhotographyConsent {
                HStack(spacing: 8) {
                    Image(systemName: "camera.fill")
                        .accessibilityHidden(true)
                    Text("No Photography Consent")
                        .font(.caption.weight(.semibold))
                }
                .foregroundStyle(Color.textPrimary)
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.warningAmber.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: LayoutConstants.cardCornerRadius, style: .continuous))
            }
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(child.fullName)
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(Color.textPrimary)
                    Text("DOB \(child.dateOfBirth.ncFormattedMediumDate())")
                        .font(.subheadline)
                        .foregroundStyle(Color.textSecondary)
                    Text(child.roomName)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color.primaryTeal)
                }
                Spacer(minLength: 0)
            }
        }
        .padding(.horizontal, LayoutConstants.horizontalPadding)
        .padding(.top, LayoutConstants.verticalPadding)
    }

    private var diarySection: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    SectionHeaderView(title: "Today’s diary", subtitle: "Chronological care log")
                    Spacer(minLength: 0)
                    TimestampComplianceInfoButton()
                }
                .padding(.horizontal, LayoutConstants.horizontalPadding)

                if entries.isEmpty {
                    EmptyStateView(
                        icon: "calendar.badge.clock",
                        title: "No entries yet today",
                        message: "Capture meals, sleep, and learning moments as they happen."
                    )
                } else {
                    VStack(spacing: 12) {
                        ForEach(entries, id: \.id) { entry in
                            DiaryEntryCard(entry: entry)
                        }
                    }
                    .padding(.horizontal, LayoutConstants.horizontalPadding)
                }

                Button {
                    isPresentingAddEntry = true
                } label: {
                    Text("Add Entry")
                        .font(.headline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primaryTeal)
                        .foregroundStyle(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: LayoutConstants.cardCornerRadius, style: .continuous))
                }
                .padding(.horizontal, LayoutConstants.horizontalPadding)
                .padding(.bottom, 24)
                .accessibilityIdentifier("DiaryAddEntryButton")
            }
        }
    }

    private var profileSection: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if !child.allergies.isEmpty {
                    AllergyWarningBanner(allergies: child.allergies)
                }
                VStack(spacing: 12) {
                    InfoCardView(
                        title: "Preferred name",
                        content: child.preferredName,
                        icon: "person.fill"
                    )
                    InfoCardView(
                        title: "Full name",
                        content: child.fullName,
                        icon: "person.text.rectangle"
                    )
                    InfoCardView(
                        title: "Date of birth",
                        content: child.dateOfBirth.ncFormattedMediumDate(),
                        icon: "calendar"
                    )
                    InfoCardView(
                        title: "Room",
                        content: child.roomName,
                        icon: "house.fill"
                    )
                    InfoCardView(
                        title: "Allergies",
                        content: child.allergies.isEmpty ? "None recorded" : child.allergies.joined(separator: ", "),
                        icon: "exclamationmark.shield.fill"
                    )
                    InfoCardView(
                        title: "Dietary notes",
                        content: child.dietaryNotes,
                        icon: "leaf.fill"
                    )
                }
                .padding(.horizontal, LayoutConstants.horizontalPadding)
                .padding(.bottom, 24)
            }
        }
    }

    /// Reloads today’s diary rows from SwiftData.
    private func reloadEntries() {
        entries = diaryViewModel.fetchEntriesForChild()
    }
}

#Preview {
    NavigationStack {
        ChildDiaryView(
            child: Child(
                id: UUID(),
                fullName: "Amelia Rose Thompson",
                preferredName: "Amelia",
                dateOfBirth: Date(),
                roomName: "Sunshine Room",
                profileColorHex: "#5C6BC0",
                allergies: ["Peanuts"],
                dietaryNotes: "Nut free",
                hasPhotographyConsent: true
            )
        )
    }
    .modelContainer(for: [Child.self, DiaryEntry.self, IncidentReport.self, BodyMapMarker.self], inMemory: true)
}
