//
//  AddDiaryEntryDynamicForm.swift
//  NurseryConnect
//
//  Purpose: Type-specific fields for the add-diary sheet.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import SwiftUI

// MARK: - AddDiaryEntryDynamicForm

/// Renders fields that change with the selected diary type.
struct AddDiaryEntryDynamicForm: View {
    /// Mutable draft bound from the parent sheet.
    @Binding var draft: DiaryEntryDraft
    /// Field-level validation messages.
    let validation: [String: String]
    /// Whether validation chrome should display.
    let showValidation: Bool
    /// Child profile for meal allergy heuristics.
    let child: Child

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            switch draft.entryType {
            case .activity:
                activityFields
            case .sleep:
                sleepFields
            case .meal:
                mealFields
            case .nappy:
                nappyFields
            case .wellbeing:
                wellbeingFields
            case .milestone:
                milestoneFields
            case .departure, .arrival:
                arrivalDepartureFields
            }
        }
    }

    private var activityFields: some View {
        VStack(alignment: .leading, spacing: 12) {
            labeledField(title: "Description") {
                TextField("What happened?", text: $draft.details, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(3, reservesSpace: true)
                    .foregroundStyle(Color.textPrimary)
            }
            if shouldShowError(key: "details") {
                validationText(for: "details")
            }
            eyfsPicker
            if shouldShowError(key: "eyfsArea") {
                validationText(for: "eyfsArea")
            }
        }
    }

    private var sleepFields: some View {
        VStack(alignment: .leading, spacing: 12) {
            DatePicker("Start", selection: bindingSleepStart, displayedComponents: .hourAndMinute)
            DatePicker("End", selection: bindingSleepEnd, displayedComponents: .hourAndMinute)
            if let duration = sleepDurationText() {
                Text(duration)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.primaryTeal)
            }
            if shouldShowError(key: "sleep") || shouldShowError(key: "sleepEnd") {
                validationText(for: "sleepEnd")
                validationText(for: "sleep")
            }
        }
    }

    private var mealFields: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !child.allergies.isEmpty {
                AllergyWarningBanner(allergies: child.allergies)
                if mealConflictDetected {
                    Text("Check this meal against recorded allergens in the description below.")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.alertRed)
                }
            }
            Picker("Meal", selection: bindingMealSlot) {
                ForEach(MealSlot.allCases, id: \.self) { slot in
                    Text(slot.displayTitle).tag(Optional(slot))
                }
            }
            if shouldShowError(key: "mealSlot") {
                validationText(for: "mealSlot")
            }
            Picker("Amount eaten", selection: bindingMealConsumption) {
                ForEach(MealConsumption.allCases, id: \.self) { item in
                    Text(item.displayTitle).tag(Optional(item))
                }
            }
            if shouldShowError(key: "mealConsumption") {
                validationText(for: "mealConsumption")
            }
            Stepper(value: $draft.fluidIntakeMl, in: 0...1000, step: 10) {
                Text("Fluid intake: \(draft.fluidIntakeMl) ml")
            }
            if shouldShowError(key: "fluid") {
                validationText(for: "fluid")
            }
            Picker("Drink", selection: bindingDrinkType) {
                ForEach(DrinkType.allCases, id: \.self) { drink in
                    Text(drink.displayTitle).tag(Optional(drink))
                }
            }
            if shouldShowError(key: "drinkType") {
                validationText(for: "drinkType")
            }
            labeledField(title: "Meal notes") {
                TextField("Foods offered and response", text: $draft.details, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(3, reservesSpace: true)
            }
        }
    }

    private var nappyFields: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Change time uses the automatic diary timestamp when you save.")
                .font(.caption)
                .foregroundStyle(Color.textSecondary)
            Picker("Nappy", selection: bindingNappyType) {
                ForEach(NappyChangeType.allCases, id: \.self) { value in
                    Text(value.displayTitle).tag(Optional(value))
                }
            }
            if shouldShowError(key: "nappyType") {
                validationText(for: "nappyType")
            }
            labeledField(title: "Notes") {
                TextField("Optional notes", text: $draft.nappyNotes, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }

    private var wellbeingFields: some View {
        VStack(alignment: .leading, spacing: 12) {
            Picker("Mood", selection: bindingMood) {
                ForEach(MoodRating.allCases, id: \.self) { mood in
                    Text("\(mood.displayEmoji) \(mood.displayTitle)").tag(Optional(mood))
                }
            }
            if shouldShowError(key: "mood") {
                validationText(for: "mood")
            }
            labeledField(title: "Observations") {
                TextField("What did you notice?", text: $draft.details, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(3, reservesSpace: true)
            }
            if shouldShowError(key: "details") {
                validationText(for: "details")
            }
        }
    }

    private var milestoneFields: some View {
        VStack(alignment: .leading, spacing: 12) {
            eyfsPicker
            if shouldShowError(key: "eyfsArea") {
                validationText(for: "eyfsArea")
            }
            labeledField(title: "Milestone") {
                TextField("Describe the milestone", text: $draft.details, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(3, reservesSpace: true)
            }
            if shouldShowError(key: "details") {
                validationText(for: "details")
            }
            labeledField(title: "Next steps") {
                TextField("Suggested next steps", text: $draft.milestoneNextSteps, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
            }
            if shouldShowError(key: "nextSteps") {
                validationText(for: "nextSteps")
            }
        }
    }

    private var arrivalDepartureFields: some View {
        VStack(alignment: .leading, spacing: 12) {
            labeledField(title: "Notes") {
                TextField("Handover notes", text: $draft.details, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(3, reservesSpace: true)
            }
            if shouldShowError(key: "details") {
                validationText(for: "details")
            }
        }
    }

    private var eyfsPicker: some View {
        Picker("EYFS area", selection: bindingEyfs) {
            Text("Select").tag(Optional<EYFSArea>.none)
            ForEach(EYFSArea.allCases, id: \.self) { area in
                Text(area.displayTitle).tag(Optional(area))
            }
        }
    }

    private func labeledField(title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.textPrimary)
            content()
        }
    }

    private func shouldShowError(key: String) -> Bool {
        showValidation && validation[key] != nil
    }

    private func validationText(for key: String) -> some View {
        Group {
            if let message = validation[key] {
                Text(message)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color.alertRed)
            }
        }
    }

    private var mealConflictDetected: Bool {
        draft.details.ncContainsAnyAllergyKeyword(allergies: child.allergies)
    }

    private var bindingEyfs: Binding<EYFSArea?> {
        Binding(
            get: { draft.eyfsArea },
            set: { draft.eyfsArea = $0 }
        )
    }

    private var bindingMood: Binding<MoodRating?> {
        Binding(
            get: { draft.moodRating },
            set: { draft.moodRating = $0 }
        )
    }

    private var bindingMealSlot: Binding<MealSlot?> {
        Binding(
            get: { draft.mealSlot },
            set: { draft.mealSlot = $0 }
        )
    }

    private var bindingMealConsumption: Binding<MealConsumption?> {
        Binding(
            get: { draft.mealConsumption },
            set: { draft.mealConsumption = $0 }
        )
    }

    private var bindingDrinkType: Binding<DrinkType?> {
        Binding(
            get: { draft.drinkType },
            set: { draft.drinkType = $0 }
        )
    }

    private var bindingNappyType: Binding<NappyChangeType?> {
        Binding(
            get: { draft.nappyType },
            set: { draft.nappyType = $0 }
        )
    }

    private var bindingSleepStart: Binding<Date> {
        Binding(
            get: { draft.sleepStart ?? Date() },
            set: { draft.sleepStart = $0 }
        )
    }

    private var bindingSleepEnd: Binding<Date> {
        Binding(
            get: { draft.sleepEnd ?? Date() },
            set: { draft.sleepEnd = $0 }
        )
    }

    private func sleepDurationText() -> String? {
        guard let start = draft.sleepStart, let end = draft.sleepEnd, end > start else {
            return nil
        }
        let minutes = Int(end.timeIntervalSince(start) / 60)
        let hours = minutes / 60
        let remainder = minutes % 60
        return "Duration: \(hours)h \(remainder)m"
    }
}
