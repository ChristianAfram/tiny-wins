import UserNotifications

/// Schedules a single, repeating local "tiny win" reminder.
///
/// Notification rules:
/// - Ask permission only after explaining the benefit.
/// - Do not nag if permission is denied.
/// - Allow reminders to be disabled.
/// - Do not use guilt-based notification copy.
/// - Do not send medical, urgent, or mental-health-sensitive claims.
final class NotificationService {
    private let center = UNUserNotificationCenter.current()
    private let reminderIdentifier = "daily-tiny-win-reminder"

    func requestPermission() async throws -> Bool {
        try await center.requestAuthorization(options: [.alert, .sound, .badge])
    }

    func currentAuthorizationStatusGranted() async -> Bool {
        let settings = await center.notificationSettings()

        switch settings.authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            return true
        default:
            return false
        }
    }

    func scheduleDailyReminder(hour: Int, minute: Int) async {
        center.removePendingNotificationRequests(withIdentifiers: [reminderIdentifier])

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let content = UNMutableNotificationContent()
        content.title = "Your tiny win is waiting"
        content.body = "One small action is enough today."
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: reminderIdentifier,
            content: content,
            trigger: trigger
        )

        do {
            try await center.add(request)
        } catch {
            assertionFailure("Failed to schedule reminder: \(error)")
        }
    }

    func cancelDailyReminder() {
        center.removePendingNotificationRequests(withIdentifiers: [reminderIdentifier])
    }
}
