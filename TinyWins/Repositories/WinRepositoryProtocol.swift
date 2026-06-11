import Foundation

enum WinRepositoryError: Error, Equatable {
    case winNotFound
}

/// Abstraction over persistence so view models and services can be unit
/// tested with an in-memory implementation instead of real SwiftData.
protocol WinRepositoryProtocol {
    func getWin(for dateKey: String) throws -> DailyWin?
    func upsertWin(dateKey: String, title: String, category: WinCategory) throws
    func markCompleted(dateKey: String, completedAt: Date) throws
    func getWins(from startDateKey: String, to endDateKey: String) throws -> [DailyWin]
    func getAllWins() throws -> [DailyWin]
    func deleteAllData() throws
}
