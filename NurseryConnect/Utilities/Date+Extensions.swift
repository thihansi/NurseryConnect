//
//  Date+Extensions.swift
//  NurseryConnect
//
//  Purpose: Shared date formatting for lists and headers.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import Foundation

// MARK: - DateFormatting

extension Date {
    /// Formats the receiver as a medium date in the current locale.
    /// - Parameter calendar: Calendar used for components (default `.current`).
    /// - Returns: Localised date string.
    func ncFormattedMediumDate(calendar: Calendar = .current) -> String {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = Locale.current
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }

    /// Formats time only for timeline rows.
    /// - Parameter calendar: Calendar for conversion.
    /// - Returns: Short time string.
    func ncFormattedShortTime(calendar: Calendar = .current) -> String {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = Locale.current
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }

    /// Formats date and time for incident headers.
    /// - Parameter calendar: Calendar for conversion.
    /// - Returns: Medium date and short time.
    func ncFormattedDateTime(calendar: Calendar = .current) -> String {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = Locale.current
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }

    /// Returns whether this instant falls on the same calendar day as another.
    /// - Parameters:
    ///   - other: Comparison date.
    ///   - calendar: Calendar boundary rules.
    /// - Returns: True when calendar days match.
    func ncIsSameDay(as other: Date, calendar: Calendar = .current) -> Bool {
        calendar.isDate(self, inSameDayAs: other)
    }
}
