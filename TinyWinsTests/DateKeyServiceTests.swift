import XCTest
@testable import TinyWins

final class DateKeyServiceTests: XCTestCase {
    private func utcCalendar() -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }

    func testSameDayReturnsSameKey() {
        let calendar = utcCalendar()
        let service = DateKeyService(calendar: calendar)
        let morning = calendar.date(from: DateComponents(year: 2026, month: 6, day: 11, hour: 9))!
        let night = calendar.date(from: DateComponents(year: 2026, month: 6, day: 11, hour: 23, minute: 59))!

        XCTAssertEqual(service.dateKey(for: morning), service.dateKey(for: night))
        XCTAssertEqual(service.dateKey(for: morning), "2026-06-11")
    }

    func testMidnightBoundary() {
        let calendar = utcCalendar()
        let service = DateKeyService(calendar: calendar)
        let beforeMidnight = calendar.date(from: DateComponents(year: 2026, month: 6, day: 11, hour: 23, minute: 59, second: 59))!
        let afterMidnight = calendar.date(from: DateComponents(year: 2026, month: 6, day: 12, hour: 0, minute: 0, second: 0))!

        XCTAssertEqual(service.dateKey(for: beforeMidnight), "2026-06-11")
        XCTAssertEqual(service.dateKey(for: afterMidnight), "2026-06-12")
    }

    func testDaylightSavingTimeTransition() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "America/New_York")!
        let service = DateKeyService(calendar: calendar)

        // US spring-forward 2026: March 8, 2026, clocks jump from 2:00 AM to 3:00 AM.
        let beforeTransition = calendar.date(from: DateComponents(year: 2026, month: 3, day: 8, hour: 1, minute: 30))!
        let afterTransition = calendar.date(from: DateComponents(year: 2026, month: 3, day: 8, hour: 3, minute: 30))!

        XCTAssertEqual(service.dateKey(for: beforeTransition), "2026-03-08")
        XCTAssertEqual(service.dateKey(for: afterTransition), "2026-03-08")
    }

    func testTimezoneChangeProducesDifferentKeyForSameInstant() {
        var utc = Calendar(identifier: .gregorian)
        utc.timeZone = TimeZone(identifier: "UTC")!
        var tokyo = Calendar(identifier: .gregorian)
        tokyo.timeZone = TimeZone(identifier: "Asia/Tokyo")!

        let utcService = DateKeyService(calendar: utc)
        let tokyoService = DateKeyService(calendar: tokyo)

        let instant = utc.date(from: DateComponents(year: 2026, month: 6, day: 11, hour: 23, minute: 0))!

        XCTAssertEqual(utcService.dateKey(for: instant), "2026-06-11")
        XCTAssertEqual(tokyoService.dateKey(for: instant), "2026-06-12")
    }

    func testLeapYearDate() {
        let calendar = utcCalendar()
        let service = DateKeyService(calendar: calendar)
        let leapDay = calendar.date(from: DateComponents(year: 2024, month: 2, day: 29))!

        XCTAssertEqual(service.dateKey(for: leapDay), "2024-02-29")
    }

    func testPreviousDayCrossesMonthBoundary() {
        let calendar = utcCalendar()
        let service = DateKeyService(calendar: calendar)
        let firstOfMonth = calendar.date(from: DateComponents(year: 2026, month: 3, day: 1))!

        let previous = service.previousDay(from: firstOfMonth)!

        XCTAssertEqual(service.dateKey(for: previous), "2026-02-28")
    }

    func testPreviousDayCrossesYearBoundary() {
        let calendar = utcCalendar()
        let service = DateKeyService(calendar: calendar)
        let newYearsDay = calendar.date(from: DateComponents(year: 2026, month: 1, day: 1))!

        let previous = service.previousDay(from: newYearsDay)!

        XCTAssertEqual(service.dateKey(for: previous), "2025-12-31")
    }

    func testStartOfTodayIsMidnight() {
        let calendar = utcCalendar()
        let service = DateKeyService(calendar: calendar)
        let startOfToday = service.startOfToday()
        let components = calendar.dateComponents([.hour, .minute, .second], from: startOfToday)

        XCTAssertEqual(components.hour, 0)
        XCTAssertEqual(components.minute, 0)
        XCTAssertEqual(components.second, 0)
    }
}
