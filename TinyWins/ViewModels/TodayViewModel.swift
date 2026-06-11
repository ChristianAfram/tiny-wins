import Foundation

@MainActor
final class TodayViewModel: ObservableObject {
    @Published private(set) var todayWin: DailyWin?
    @Published private(set) var streakDisplay = StreakDisplay(count: 0, includesToday: false)
    @Published var customTitle: String = ""
    @Published var selectedCategory: WinCategory = .custom

    let suggestionService = SuggestionService()

    private let repository: WinRepositoryProtocol
    private let streakService: StreakService
    private let dateKeyService: DateKeyService

    init(
        repository: WinRepositoryProtocol,
        streakService: StreakService = StreakService(),
        dateKeyService: DateKeyService = DateKeyService()
    ) {
        self.repository = repository
        self.streakService = streakService
        self.dateKeyService = dateKeyService
    }

    var todayKey: String {
        dateKeyService.dateKey()
    }

    var isCompleted: Bool {
        todayWin?.status == .completed
    }

    func loadToday() {
        do {
            todayWin = try repository.getWin(for: todayKey)
            try refreshStreak()
        } catch {
            assertionFailure("Failed to load today's win: \(error)")
        }
    }

    func selectSuggestion(_ suggestion: TinyWinSuggestion) {
        save(title: suggestion.title, category: suggestion.category)
    }

    func saveCustomWin() {
        let trimmed = customTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        save(title: trimmed, category: selectedCategory)
        customTitle = ""
    }

    /// Pre-fills the picker fields so the user can edit today's win before
    /// completing it.
    func beginEditingTodayWin() {
        guard let win = todayWin else { return }
        customTitle = win.title
        selectedCategory = win.category
    }

    func markComplete() {
        guard todayWin != nil, !isCompleted else { return }

        do {
            try repository.markCompleted(dateKey: todayKey, completedAt: Date())
            loadToday()
            DebugMetricsLogger.log(.winCompleted)
        } catch {
            assertionFailure("Failed to mark win complete: \(error)")
        }
    }

    private func save(title: String, category: WinCategory) {
        let isNewWin = todayWin == nil

        do {
            try repository.upsertWin(dateKey: todayKey, title: title, category: category)
            loadToday()

            if isNewWin {
                DebugMetricsLogger.log(.winCreated)
            }
        } catch {
            assertionFailure("Failed to save today's win: \(error)")
        }
    }

    private func refreshStreak() throws {
        let allWins = try repository.getAllWins()
        streakDisplay = streakService.displayStreak(records: allWins)
    }
}
