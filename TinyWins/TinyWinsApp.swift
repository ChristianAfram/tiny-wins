import SwiftUI
import SwiftData

@main
struct TinyWinsApp: App {
    let modelContainer: ModelContainer

    init() {
        let isUITesting = ProcessInfo.processInfo.arguments.contains("UI-TESTING-RESET-STATE")

        if isUITesting, let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }

        do {
            let schema = Schema([DailyWin.self])
            let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: isUITesting)
            modelContainer = try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Failed to create model container: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .modelContainer(modelContainer)
        }
    }
}
