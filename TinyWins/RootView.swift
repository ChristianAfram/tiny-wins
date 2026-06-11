import SwiftUI
import SwiftData

struct RootView: View {
    @AppStorage("settings.onboardingCompleted") private var onboardingCompleted = false
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        if onboardingCompleted {
            MainTabView()
        } else {
            OnboardingView(settingsViewModel: makeSettingsViewModel())
        }
    }

    private func makeSettingsViewModel() -> SettingsViewModel {
        let repository = WinRepository(modelContext: modelContext)
        let privacyService = PrivacyService(repository: repository)
        return SettingsViewModel(privacyService: privacyService)
    }
}

private struct MainTabView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        let repository = WinRepository(modelContext: modelContext)
        let privacyService = PrivacyService(repository: repository)

        TabView {
            TodayView(viewModel: TodayViewModel(repository: repository))
                .tabItem { Label("Today", systemImage: "checkmark.circle") }

            HistoryView(viewModel: HistoryViewModel(repository: repository))
                .tabItem { Label("History", systemImage: "calendar") }

            SettingsView(
                viewModel: SettingsViewModel(privacyService: privacyService),
                privacyService: privacyService
            )
            .tabItem { Label("Settings", systemImage: "gearshape") }
        }
    }
}
