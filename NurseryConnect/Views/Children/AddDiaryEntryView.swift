//
//  AddDiaryEntryView.swift
//  NurseryConnect
//
//  Purpose: Modal sheet to capture a new diary entry with validation.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import SwiftData
import SwiftUI

// MARK: - AddDiaryEntryView

/// Sheet used from quick log and the child diary screen.
struct AddDiaryEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var diaryViewModel: DiaryViewModel
    @State private var draft: DiaryEntryDraft
    @State private var validation: [String: String] = [:]
    @State private var didAttemptSave = false

    private let child: Child

    /// Creates the sheet bound to a specific child.
    /// - Parameters:
    ///   - modelContext: SwiftData context for persistence.
    ///   - child: Target profile.
    ///   - initialType: Starting diary type selection.
    init(modelContext: ModelContext, child: Child, initialType: DiaryEntryType) {
        self.child = child
        _diaryViewModel = StateObject(wrappedValue: DiaryViewModel(childId: child.id, modelContext: modelContext))
        _draft = State(initialValue: DiaryEntryDraft.empty(childId: child.id, entryType: initialType))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Text("Logged at")
                            .font(.subheadline.weight(.semibold))
                        Spacer()
                        Text(Date().ncFormattedDateTime())
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Color.textSecondary)
                        TimestampComplianceInfoButton()
                    }
                }

                Section("Entry type") {
                    Picker("Type", selection: $draft.entryType) {
                        ForEach(DiaryEntryType.allCases, id: \.self) { type in
                            Text(type.displayTitle).tag(type)
                        }
                    }
                    .onChange(of: draft.entryType) { _, newValue in
                        draft = DiaryEntryDraft.empty(childId: child.id, entryType: newValue)
                    }
                }

                Section("Details") {
                    AddDiaryEntryDynamicForm(
                        draft: $draft,
                        validation: validation,
                        showValidation: didAttemptSave,
                        child: child
                    )
                }
            }
            .navigationTitle("New diary entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save Entry") {
                        attemptSave()
                    }
                    .fontWeight(.semibold)
                    .accessibilityIdentifier("DiarySaveEntryButton")
                }
            }
        }
    }

    /// Validates and persists the draft when possible.
    private func attemptSave() {
        didAttemptSave = true
        validation = diaryViewModel.validateEntry(draft)
        if !validation.isEmpty {
            return
        }
        let didSave = diaryViewModel.addEntry(draft)
        if didSave {
            dismiss()
        }
    }
}

#Preview("AddDiaryEntryView") {
    Text("Run on device or open from Child Diary in simulator for a live preview with SwiftData.")
        .padding()
}
