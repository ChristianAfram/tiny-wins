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
