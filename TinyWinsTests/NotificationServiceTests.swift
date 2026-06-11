import XCTest
import UserNotifications
@testable import TinyWins

private final class MockNotificationCenter: NotificationCenterProtocol {
    var requestAuthorizationResult: Result<Bool, Error> = .success(true)
    var authorizationStatusToReturn: UNAuthorizationStatus = .notDetermined
    var addedRequests: [UNNotificationRequest] = []
    var removedIdentifiers: [[String]] = []
    var pendingRequests: [UNNotificationRequest] = []

    func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool {
        try requestAuthorizationResult.get()
    }

    func authorizationStatus() async -> UNAuthorizationStatus {
        authorizationStatusToReturn
    }

    func add(_ request: UNNotificationRequest) async throws {
        addedRequests.append(request)
        pendingRequests.append(request)
    }

    func removePendingNotificationRequests(withIdentifiers identifiers: [String]) {
        removedIdentifiers.append(identifiers)
        pendingRequests.removeAll { identifiers.contains($0.identifier) }
    }

    func pendingNotificationRequests() async -> [UNNotificationRequest] {
        pendingRequests
    }
}

final class NotificationServiceTests: XCTestCase {
    private let reminderIdentifier = "daily-tiny-win-reminder"

    func testRequestPermissionReturnsGrantedResult() async throws {
        let center = MockNotificationCenter()
        center.requestAuthorizationResult = .success(true)
        let service = NotificationService(center: center)

        let granted = try await service.requestPermission()

        XCTAssertTrue(granted)
    }

    func testRequestPermissionReturnsDeniedResult() async throws {
        let center = MockNotificationCenter()
        center.requestAuthorizationResult = .success(false)
        let service = NotificationService(center: center)

        let granted = try await service.requestPermission()

        XCTAssertFalse(granted)
    }

    func testCurrentAuthorizationStatusGrantedForAuthorizedStatuses() async {
        for status: UNAuthorizationStatus in [.authorized, .provisional, .ephemeral] {
            let center = MockNotificationCenter()
            center.authorizationStatusToReturn = status
            let service = NotificationService(center: center)

            let granted = await service.currentAuthorizationStatusGranted()

            XCTAssertTrue(granted, "Expected \(status) to be considered granted")
        }
    }

    func testCurrentAuthorizationStatusGrantedFalseForDeniedAndNotDetermined() async {
        for status: UNAuthorizationStatus in [.denied, .notDetermined] {
            let center = MockNotificationCenter()
            center.authorizationStatusToReturn = status
            let service = NotificationService(center: center)

            let granted = await service.currentAuthorizationStatusGranted()

            XCTAssertFalse(granted, "Expected \(status) to not be considered granted")
        }
    }

    func testScheduleDailyReminderRemovesExistingAndAddsNewRequest() async throws {
        let center = MockNotificationCenter()
        let service = NotificationService(center: center)

        await service.scheduleDailyReminder(hour: 9, minute: 30)

        XCTAssertEqual(center.removedIdentifiers.last, [reminderIdentifier])
        XCTAssertEqual(center.addedRequests.count, 1)

        let request = try XCTUnwrap(center.addedRequests.first)
        XCTAssertEqual(request.identifier, reminderIdentifier)

        let trigger = try XCTUnwrap(request.trigger as? UNCalendarNotificationTrigger)
        XCTAssertEqual(trigger.dateComponents.hour, 9)
        XCTAssertEqual(trigger.dateComponents.minute, 30)
        XCTAssertTrue(trigger.repeats)
    }

    func testCancelDailyReminderRemovesPendingRequest() async {
        let center = MockNotificationCenter()
        let service = NotificationService(center: center)

        await service.scheduleDailyReminder(hour: 8, minute: 0)
        service.cancelDailyReminder()

        let pending = await center.pendingNotificationRequests()
        XCTAssertTrue(pending.isEmpty)
        XCTAssertEqual(center.removedIdentifiers.last, [reminderIdentifier])
    }
}
