import XCTest
@testable import TinyWins

final class StreakServiceTests: XCTestCase {
    private func utcCalendar() -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }

    private func makeServices() -> (DateKeyService, StreakService, Calendar) {
        let calendar = utcCalendar()
        let dateKeyService = DateKeyService(calendar: calendar)
        let streakService = StreakService(dateKeyService: dateKeyService, calendar: calendar)
        return (dateKeyService, streakService, calendar)
    }

    private func completedWin(dateKey: String) -> DailyWin {
        DailyWin(dateKey: dateKey, title: "Test win", category: .custom, status: .completed)
    }

    func testEmptyHistoryReturnsZero() {
        let (_, streakService, calendar) = makeServices()
        let now = calendar.date(from: DateComponents(year: 2026, month: 6, day: 11))!

        XCTAssertEqual(streakService.currentStreak(records: [], now: now), 0)
    }

    func testMissedYesterdayLimitsStreakToToday() {
        let (dateKeyService, streakService, calendar) = makeServices()
        let now = calendar.date(from: DateComponents(year: 2026, month: 6, day: 11))!

        let records = [completedWin(dateKey: dateKeyService.dateKey(for: now))]

        XCTAssertEqual(streakService.currentStreak(records: records, now: now), 1)
    }

    func testCompletedTodayButNotYesterdayGivesStreakOfOne() {
        let (dateKeyService, streakService, calendar) = makeServices()
        let now = calendar.date(from: DateComponents(year: 2026, month: 6, day: 11))!
        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: now)!

        let records = [
            completedWin(dateKey: dateKeyService.dateKey(for: now)),
            completedWin(dateKey: dateKeyService.dateKey(for: twoDaysAgo))
        ]

        XCTAssertEqual(streakService.currentStreak(records: records, now: now), 1)
    }

    func testConsecutiveStreakAcrossMonthBoundary() {
        let (dateKeyService, streakService, calendar) = makeServices()
        let now = calendar.date(from: DateComponents(year: 2026, month: 3, day: 1))!
        let yesterday = calendar.date(from: DateComponents(year: 2026, month: 2, day: 28))!

        let records = [
            completedWin(dateKey: dateKeyService.dateKey(for: now)),
            completedWin(dateKey: dateKeyService.dateKey(for: yesterday))
        ]

        XCTAssertEqual(streakService.currentStreak(records: records, now: now), 2)
    }

    func testConsecutiveStreakAcrossYearBoundary() {
        let (dateKeyService, streakService, calendar) = makeServices()
        let now = calendar.date(from: DateComponents(year: 2026, month: 1, day: 1))!
        let yesterday = calendar.date(from: DateComponents(year: 2025, month: 12, day: 31))!

        let records = [
            completedWin(dateKey: dateKeyService.dateKey(for: now)),
            completedWin(dateKey: dateKeyService.dateKey(for: yesterday))
        ]

        XCTAssertEqual(streakService.currentStreak(records: records, now: now), 2)
    }

    func testDisplayStreakIncludesTodayFlagWhenTodayCompleted() {
        let (dateKeyService, streakService, calendar) = makeServices()
        let now = calendar.date(from: DateComponents(year: 2026, month: 6, day: 11))!

        let records = [completedWin(dateKey: dateKeyService.dateKey(for: now))]
        let display = streakService.displayStreak(records: records, now: now)

        XCTAssertEqual(display.count, 1)
        XCTAssertTrue(display.includesToday)
    }

    func testDisplayStreakWhenTodayNotCompleted() {
        let (dateKeyService, streakService, calendar) = makeServices()
        let now = calendar.date(from: DateComponents(year: 2026, month: 6, day: 11))!
        let yesterday = calendar.date(byAdding: .day, value: -1, to: now)!

        let records = [completedWin(dateKey: dateKeyService.dateKey(for: yesterday))]
        let display = streakService.displayStreak(records: records, now: now)

        XCTAssertEqual(display.count, 1)
        XCTAssertFalse(display.includesToday)
    }
}
