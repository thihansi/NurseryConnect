//
//  NurseryConnectUITests.swift
//  NurseryConnectUITests
//
//  Purpose: High-level UI flows for diary capture and incident reporting.
//  Author: Thihansi Gunawardena
//  Date: 2026-04-12
//

import XCTest

// MARK: - NurseryConnectUITests

/// UI automation coverage for the keyworker experience.
final class NurseryConnectUITests: XCTestCase {
    /// Shared application instance for each test.
    private var app: XCUIApplication!

    /// Launches a fresh application instance.
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }

    /// Walks from the seeded child list through diary capture.
    func testNavigateChildDiaryAddEntry() throws {
        app.launch()

        let list = app.tables["MyChildrenList"]
        XCTAssertTrue(list.waitForExistence(timeout: 5))
        let firstCell = list.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
        firstCell.tap()

        let addButton = app.buttons["DiaryAddEntryButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
        addButton.tap()

        let description = app.textFields["DiaryActivityDescription"]
        XCTAssertTrue(description.waitForExistence(timeout: 5))
        description.tap()
        description.typeText("UITest outdoor play observation")

        app.pickers["EYFS area"].tap()
        let eyfsWheel = app.pickerWheels.element(boundBy: 0)
        if eyfsWheel.waitForExistence(timeout: 2) {
            eyfsWheel.adjust(toPickerWheelValue: "Expressive Arts & Design")
        }

        app.buttons["DiarySaveEntryButton"].tap()

        XCTAssertTrue(app.staticTexts["UITest outdoor play observation"].waitForExistence(timeout: 5))
    }

    /// Completes the four-step incident wizard and verifies list content.
    func testCreateIncidentThroughWizard() throws {
        app.launch()

        app.tabBars.buttons["Incidents"].tap()

        app.buttons["ReportNewIncidentButton"].tap()

        app.pickers["IncidentChildPicker"].tap()
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "Amelia")

        app.pickers["IncidentCategoryPicker"].tap()
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "Near miss")

        let location = app.textFields["IncidentLocationField"]
        XCTAssertTrue(location.waitForExistence(timeout: 5))
        location.tap()
        location.typeText("Garden path")

        app.buttons["IncidentWizardNext"].tap()

        let desc = app.textViews["IncidentDescriptionField"]
        XCTAssertTrue(desc.waitForExistence(timeout: 5))
        desc.tap()
        desc.typeText("Child almost tripped on hose.")

        let immediate = app.textViews["IncidentImmediateField"]
        immediate.tap()
        immediate.typeText("Hose moved and area checked.")

        app.buttons["IncidentWizardNext"].tap()
        app.buttons["IncidentWizardNext"].tap()

        app.buttons["IncidentSubmitReview"].tap()

        XCTAssertTrue(app.staticTexts["Amelia Rose Thompson"].waitForExistence(timeout: 5))
    }

    /// Ensures empty copy appears when no seed data is injected.
    func testEmptyStatesWithoutSeed() throws {
        app.launchArguments = [LaunchArguments.skipSampleSeed]
        app.launch()

        XCTAssertTrue(app.staticTexts["No assigned children"].waitForExistence(timeout: 5))

        app.tabBars.buttons["Incidents"].tap()
        XCTAssertTrue(app.staticTexts["No incidents match this filter"].waitForExistence(timeout: 5))
    }
}
