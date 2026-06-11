import XCTest

final class SettingsFlowUITests: XCTestCase {
    private func completeOnboardingIfNeeded(_ app: XCUIApplication) {
        guard app.buttons["Continue"].waitForExistence(timeout: 5) else { return }

        app.buttons["Continue"].tap()
        app.buttons["Get Started"].tap()
    }

    func testUserCanEnableReminderAndChangeTime() {
        let app = XCUIApplication()
        app.launchArguments += ["UI-TESTING-RESET-STATE"]
        app.launch()

        completeOnboardingIfNeeded(app)

        addUIInterruptionMonitor(withDescription: "Notification permission") { alert in
            guard alert.buttons["Allow"].exists else { return false }
            alert.buttons["Allow"].tap()
            return true
        }

        app.tabBars.buttons["Settings"].tap()
        XCTAssertTrue(app.navigationBars["Settings"].waitForExistence(timeout: 5))

        let reminderToggle = app.switches["Daily reminder"]
        XCTAssertTrue(reminderToggle.waitForExistence(timeout: 5))
        reminderToggle.tap()
        app.navigationBars["Settings"].tap()

        let datePicker = app.datePickers["Reminder time"]
        XCTAssertTrue(datePicker.waitForExistence(timeout: 5))

        let hourWheel = datePicker.pickerWheels.element(boundBy: 0)
        XCTAssertTrue(hourWheel.waitForExistence(timeout: 5))

        let initialHour = hourWheel.value as? String
        hourWheel.swipeUp()

        XCTAssertNotEqual(hourWheel.value as? String, initialHour)
    }

    func testUserCanDeleteAllData() {
        let app = XCUIApplication()
        app.launchArguments += ["UI-TESTING-RESET-STATE"]
        app.launch()

        completeOnboardingIfNeeded(app)

        XCTAssertTrue(app.buttons["Choose a tiny win"].waitForExistence(timeout: 5))
        app.buttons["Choose a tiny win"].tap()

        let suggestion = app.staticTexts["Drink a glass of water"]
        XCTAssertTrue(suggestion.waitForExistence(timeout: 5))
        suggestion.tap()
        app.buttons["Mark as complete"].tap()
        XCTAssertTrue(app.staticTexts["Completed"].waitForExistence(timeout: 5))

        app.tabBars.buttons["Settings"].tap()
        XCTAssertTrue(app.navigationBars["Settings"].waitForExistence(timeout: 5))

        app.buttons["Delete all local data"].tap()

        let alert = app.alerts["Delete all data?"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5))
        alert.buttons["Delete"].tap()

        XCTAssertTrue(app.staticTexts["Tiny Wins"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["Continue"].waitForExistence(timeout: 5))
    }
}
