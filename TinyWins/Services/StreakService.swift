import Foundation

struct StreakDisplay {
    let count: Int
    let includesToday: Bool
}

struct StreakService {
    private let dateKeyService: DateKeyService
    private let calendar: Calendar

    init(
        dateKeyService: DateKeyService = DateKeyService(),
        calendar: Calendar = .autoupdatingCurrent
    ) {
        self.dateKeyService = dateKeyService
        self.calendar = calendar
    }

    /// Counts consecutive completed days ending today. If today is not yet
    /// completed, the streak is based on yesterday instead, since the
    /// current day hasn't ended and shouldn't break the streak yet.
    func currentStreak(records: [DailyWin], now: Date = Date()) -> Int {
        let completedKeys = Set(
            records
                .filter { $0.statusRawValue == WinStatus.completed.rawValue }
                .map { $0.dateKey }
        )

        var streak = 0
        var cursor = calendar.startOfDay(for: now)

        if !completedKeys.contains(dateKeyService.dateKey(for: cursor)) {
            guard let yesterday = calendar.date(byAdding: .day, value: -1, to: cursor) else {
                return 0
            }

            cursor = yesterday
        }

        while true {
            let key = dateKeyService.dateKey(for: cursor)

            guard completedKeys.contains(key) else {
                break
            }

            streak += 1

            guard let previous = calendar.date(byAdding: .day, value: -1, to: cursor) else {
                break
            }

            cursor = previous
        }

        return streak
    }

    func displayStreak(records: [DailyWin], now: Date = Date()) -> StreakDisplay {
        let todayKey = dateKeyService.dateKey(for: now)
        let todayCompleted = records.contains {
            $0.dateKey == todayKey && $0.statusRawValue == WinStatus.completed.rawValue
        }

        let streak = currentStreak(records: records, now: now)

        return StreakDisplay(
            count: streak,
            includesToday: todayCompleted
        )
    }
}
