import XCTest

final class OnboardingFlowUITests: XCTestCase {
    func testOnboardingCompletesAndShowsTodayScreen() {
        let app = XCUIApplication()
        app.launchArguments += ["UI-TESTING-RESET-STATE"]
        app.launch()

        XCTAssertTrue(app.buttons["Continue"].waitForExistence(timeout: 5))
        app.buttons["Continue"].tap()

        XCTAssertTrue(app.buttons["Get Started"].waitForExistence(timeout: 5))
        app.buttons["Get Started"].tap()

        XCTAssertTrue(app.navigationBars["Today"].waitForExistence(timeout: 5))
    }
}
