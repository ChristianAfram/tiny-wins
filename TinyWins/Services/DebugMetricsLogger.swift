import Foundation

/// Local-only debug metrics for development builds.
///
/// Per the observability section of the spec, the MVP intentionally has no
/// production analytics. These events are only printed in DEBUG builds to
/// help validate the core funnel during development and TestFlight.
enum DebugMetricsEvent: String {
    case onboardingCompleted = "onboarding_completed"
    case winCreated = "win_created"
    case winCompleted = "win_completed"
    case reminderPermissionRequested = "reminder_permission_requested"
    case reminderPermissionGranted = "reminder_permission_granted"
    case reminderScheduled = "reminder_scheduled"
    case deleteAllDataTriggered = "delete_all_data_triggered"
}

enum DebugMetricsLogger {
    static func log(_ event: DebugMetricsEvent) {
        #if DEBUG
        print("[TinyWins] \(event.rawValue)")
        #endif
    }
}
