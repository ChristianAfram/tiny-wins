import Foundation

/// Converts dates to/from stable `YYYY-MM-DD` keys.
///
/// Date logic is the highest-risk part of this app because streak bugs
/// destroy user trust, so all date-key derivation is centralized here.
struct DateKeyService {
    private let calendar: Calendar

    init(calendar: Calendar = .autoupdatingCurrent) {
        self.calendar = calendar
    }

    func dateKey(for date: Date = Date()) -> String {
        let components = calendar.dateComponents([.year, .month, .day], from: date)

        guard
            let year = components.year,
            let month = components.month,
            let day = components.day
        else {
            assertionFailure("Invalid date components")
            return "invalid-date"
        }

        return String(format: "%04d-%02d-%02d", year, month, day)
    }

    func startOfToday() -> Date {
        calendar.startOfDay(for: Date())
    }

    func previousDay(from date: Date) -> Date? {
        calendar.date(byAdding: .day, value: -1, to: date)
    }
}
