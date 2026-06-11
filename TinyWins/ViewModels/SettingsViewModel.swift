import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    private enum Keys {
        static let reminderEnabled = "settings.reminderEnabled"
        static let reminderHour = "settings.reminderHour"
        static let reminderMinute = "settings.reminderMinute"
    }

    @Published var reminderEnabled: Bool {
        didSet { handleReminderEnabledChange() }
    }
    @Published var reminderHour: Int {
        didSet { persistReminderTime() }
    }
    @Published var reminderMinute: Int {
        didSet { persistReminderTime() }
    }
    @Published private(set) var notificationPermissionGranted = false
    @Published private(set) var deleteConfirmationMessage: String?

    private let notificationService: NotificationService
    private let privacyService: PrivacyService
    private let defaults: UserDefaults

    init(
        notificationService: NotificationService = NotificationService(),
        privacyService: PrivacyService,
        defaults: UserDefaults = .standard
    ) {
        self.notificationService = notificationService
        self.privacyService = privacyService
        self.defaults = defaults
        self.reminderEnabled = defaults.bool(forKey: Keys.reminderEnabled)
        self.reminderHour = defaults.object(forKey: Keys.reminderHour) as? Int ?? 9
        self.reminderMinute = defaults.object(forKey: Keys.reminderMinute) as? Int ?? 0
    }

    func onAppear() async {
        notificationPermissionGranted = await notificationService.currentAuthorizationStatusGranted()

        if reminderEnabled && notificationPermissionGranted {
            await notificationService.scheduleDailyReminder(hour: reminderHour, minute: reminderMinute)
        }
    }

    func enableReminders() async {
        do {
            let granted = try await notificationService.requestPermission()
            notificationPermissionGranted = granted
            reminderEnabled = granted

            if granted {
                await notificationService.scheduleDailyReminder(hour: reminderHour, minute: reminderMinute)
            }
        } catch {
            assertionFailure("Failed to request notification permission: \(error)")
        }
    }

    func deleteAllData() {
        do {
            try privacyService.deleteAllData()
            notificationService.cancelDailyReminder()
            reminderEnabled = false
            deleteConfirmationMessage = "All local data has been deleted."
        } catch {
            assertionFailure("Failed to delete all data: \(error)")
        }
    }

    private func handleReminderEnabledChange() {
        defaults.set(reminderEnabled, forKey: Keys.reminderEnabled)

        Task {
            if reminderEnabled {
                await notificationService.scheduleDailyReminder(hour: reminderHour, minute: reminderMinute)
            } else {
                notificationService.cancelDailyReminder()
            }
        }
    }

    private func persistReminderTime() {
        defaults.set(reminderHour, forKey: Keys.reminderHour)
        defaults.set(reminderMinute, forKey: Keys.reminderMinute)

        guard reminderEnabled else { return }

        Task {
            await notificationService.scheduleDailyReminder(hour: reminderHour, minute: reminderMinute)
        }
    }
}
