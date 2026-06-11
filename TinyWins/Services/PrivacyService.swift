import Foundation

/// Backs the "Delete all local data" and "View privacy explanation" controls
/// required by the privacy/data-governance section of the spec.
final class PrivacyService {
    private let repository: WinRepositoryProtocol
    private let defaults: UserDefaults
    private let settingsKeyPrefix = "settings."

    init(repository: WinRepositoryProtocol, defaults: UserDefaults = .standard) {
        self.repository = repository
        self.defaults = defaults
    }

    /// Deletes all win history and resets all locally stored preferences.
    func deleteAllData() throws {
        try repository.deleteAllData()

        for key in defaults.dictionaryRepresentation().keys where key.hasPrefix(settingsKeyPrefix) {
            defaults.removeObject(forKey: key)
        }
    }

    var privacyExplanation: String {
        """
        Tiny Wins stores everything on your device only.

        - No accounts, no sign-in.
        - No data is sent to any server.
        - No third-party analytics or advertising SDKs.
        - Reminders are scheduled locally on your device.
        - You can delete all local data at any time from Settings.
        """
    }
}
