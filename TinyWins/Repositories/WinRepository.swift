import Foundation
import SwiftData

final class WinRepository: WinRepositoryProtocol {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func getWin(for dateKey: String) throws -> DailyWin? {
        let descriptor = FetchDescriptor<DailyWin>(
            predicate: #Predicate { $0.dateKey == dateKey }
        )
        return try modelContext.fetch(descriptor).first
    }

    func upsertWin(dateKey: String, title: String, category: WinCategory) throws {
        if let existing = try getWin(for: dateKey) {
            existing.title = title
            existing.category = category
            existing.updatedAt = Date()
        } else {
            let win = DailyWin(dateKey: dateKey, title: title, category: category)
            modelContext.insert(win)
        }

        try modelContext.save()
    }

    func markCompleted(dateKey: String, completedAt: Date) throws {
        guard let win = try getWin(for: dateKey) else {
            throw WinRepositoryError.winNotFound
        }

        win.status = .completed
        win.completedAt = completedAt
        win.updatedAt = Date()

        try modelContext.save()
    }

    func getWins(from startDateKey: String, to endDateKey: String) throws -> [DailyWin] {
        let descriptor = FetchDescriptor<DailyWin>(
            predicate: #Predicate { $0.dateKey >= startDateKey && $0.dateKey <= endDateKey },
            sortBy: [SortDescriptor(\.dateKey, order: .forward)]
        )
        return try modelContext.fetch(descriptor)
    }

    func getAllWins() throws -> [DailyWin] {
        let descriptor = FetchDescriptor<DailyWin>(
            sortBy: [SortDescriptor(\.dateKey, order: .forward)]
        )
        return try modelContext.fetch(descriptor)
    }

    func deleteAllData() throws {
        for win in try getAllWins() {
            modelContext.delete(win)
        }

        try modelContext.save()
    }
}
