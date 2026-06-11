import Foundation

@MainActor
final class HistoryViewModel: ObservableObject {
    struct HistoryDay: Identifiable {
        let id: String
        let date: Date
        let win: DailyWin?
    }

    @Published private(set) var days: [HistoryDay] = []

    private let repository: WinRepositoryProtocol
    private let dateKeyService: DateKeyService
    private let calendar: Calendar

    init(
        repository: WinRepositoryProtocol,
        dateKeyService: DateKeyService = DateKeyService(),
        calendar: Calendar = .autoupdatingCurrent
    ) {
        self.repository = repository
        self.dateKeyService = dateKeyService
        self.calendar = calendar
    }

    /// Loads the last 7 days (oldest first, today last).
    func loadHistory(now: Date = Date()) {
        let today = calendar.startOfDay(for: now)
        let dates = (0..<7)
            .compactMap { calendar.date(byAdding: .day, value: -$0, to: today) }
            .reversed()
            .map { $0 }

        guard let startDate = dates.first, let endDate = dates.last else {
            days = []
            return
        }

        do {
            let wins = try repository.getWins(
                from: dateKeyService.dateKey(for: startDate),
                to: dateKeyService.dateKey(for: endDate)
            )
            let winsByKey = Dictionary(uniqueKeysWithValues: wins.map { ($0.dateKey, $0) })

            days = dates.map { date in
                let key = dateKeyService.dateKey(for: date)
                return HistoryDay(id: key, date: date, win: winsByKey[key])
            }
        } catch {
            assertionFailure("Failed to load history: \(error)")
            days = []
        }
    }
}
