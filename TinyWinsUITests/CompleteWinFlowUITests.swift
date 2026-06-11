import XCTest

final class CompleteWinFlowUITests: XCTestCase {
    private func completeOnboardingIfNeeded(_ app: XCUIApplication) {
        guard app.buttons["Continue"].waitForExistence(timeout: 5) else { return }

        app.buttons["Continue"].tap()
        app.buttons["Get Started"].tap()
    }

    func testUserCanPickSuggestionAndCompleteWin() {
        let app = XCUIApplication()
        app.launchArguments += ["UI-TESTING-RESET-STATE"]
        app.launch()

        completeOnboardingIfNeeded(app)

        XCTAssertTrue(app.buttons["Choose a tiny win"].waitForExistence(timeout: 5))
        app.buttons["Choose a tiny win"].tap()

        let suggestion = app.staticTexts["Drink a glass of water"]
        XCTAssertTrue(suggestion.waitForExistence(timeout: 5))
        suggestion.tap()

        let completeButton = app.buttons["Mark as complete"]
        XCTAssertTrue(completeButton.waitForExistence(timeout: 5))
        completeButton.tap()

        XCTAssertTrue(app.staticTexts["Completed"].waitForExistence(timeout: 5))
    }

    func testUserCanEditTodaysWinBeforeCompletion() {
        let app = XCUIApplication()
        app.launchArguments += ["UI-TESTING-RESET-STATE"]
        app.launch()

        completeOnboardingIfNeeded(app)

        app.buttons["Choose a tiny win"].tap()
        let suggestion = app.staticTexts["Drink a glass of water"]
        XCTAssertTrue(suggestion.waitForExistence(timeout: 5))
        suggestion.tap()

        let editButton = app.buttons["Edit"]
        XCTAssertTrue(editButton.waitForExistence(timeout: 5))
        editButton.tap()

        let textField = app.textFields["Describe your tiny win"]
        XCTAssertTrue(textField.waitForExistence(timeout: 5))
        XCTAssertEqual(textField.value as? String, "Drink a glass of water")

        textField.tap()
        textField.clearAndTypeText("Walk for 5 minutes")
        app.buttons["Save"].tap()

        XCTAssertTrue(app.staticTexts["Walk for 5 minutes"].waitForExistence(timeout: 5))
    }

    func testUserCanCreateCustomWin() {
        let app = XCUIApplication()
        app.launchArguments += ["UI-TESTING-RESET-STATE"]
        app.launch()

        completeOnboardingIfNeeded(app)

        XCTAssertTrue(app.buttons["Choose a tiny win"].waitForExistence(timeout: 5))
        app.buttons["Choose a tiny win"].tap()

        let textField = app.textFields["Describe your tiny win"]
        XCTAssertTrue(textField.waitForExistence(timeout: 5))
        textField.tap()
        textField.typeText("Read for 10 minutes")

        app.buttons["Save"].tap()

        XCTAssertTrue(app.staticTexts["Read for 10 minutes"].waitForExistence(timeout: 5))
    }

    func testHistoryShowsTodayAfterCompletingWin() {
        let app = XCUIApplication()
        app.launchArguments += ["UI-TESTING-RESET-STATE"]
        app.launch()

        completeOnboardingIfNeeded(app)

        app.buttons["Choose a tiny win"].tap()
        let suggestion = app.staticTexts["Drink a glass of water"]
        XCTAssertTrue(suggestion.waitForExistence(timeout: 5))
        suggestion.tap()
        app.buttons["Mark as complete"].tap()

        app.tabBars.buttons["History"].tap()

        XCTAssertTrue(app.navigationBars["Last 7 Days"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Drink a glass of water"].waitForExistence(timeout: 5))
    }
}

private extension XCUIElement {
    func clearAndTypeText(_ text: String) {
        guard let value = self.value as? String else {
            typeText(text)
            return
        }

        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: value.count)
        typeText(deleteString)
        typeText(text)
    }
}
