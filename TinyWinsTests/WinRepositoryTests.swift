import XCTest
import SwiftData
@testable import TinyWins

@MainActor
final class WinRepositoryTests: XCTestCase {
    private var container: ModelContainer!
    private var repository: WinRepository!

    override func setUpWithError() throws {
        let schema = Schema([DailyWin.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        container = try ModelContainer(for: schema, configurations: [configuration])
        repository = WinRepository(modelContext: container.mainContext)
    }

    func testUpsertCreatesNewWin() throws {
        try repository.upsertWin(dateKey: "2026-06-11", title: "Drink water", category: .health)

        let win = try repository.getWin(for: "2026-06-11")

        XCTAssertEqual(win?.title, "Drink water")
        XCTAssertEqual(win?.category, .health)
        XCTAssertEqual(win?.status, .planned)
    }

    func testUpsertUpdatesExistingWinInPlace() throws {
        try repository.upsertWin(dateKey: "2026-06-11", title: "Drink water", category: .health)
        try repository.upsertWin(dateKey: "2026-06-11", title: "Walk for 5 minutes", category: .focus)

        let allWins = try repository.getAllWins()
        let win = try repository.getWin(for: "2026-06-11")

        XCTAssertEqual(allWins.count, 1)
        XCTAssertEqual(win?.title, "Walk for 5 minutes")
        XCTAssertEqual(win?.category, .focus)
    }

    func testMarkCompletedUpdatesStatusAndTimestamp() throws {
        try repository.upsertWin(dateKey: "2026-06-11", title: "Drink water", category: .health)

        try repository.markCompleted(dateKey: "2026-06-11", completedAt: Date())

        let win = try repository.getWin(for: "2026-06-11")

        XCTAssertEqual(win?.status, .completed)
        XCTAssertNotNil(win?.completedAt)
    }

    func testMarkCompletedThrowsWhenWinDoesNotExist() {
        XCTAssertThrowsError(try repository.markCompleted(dateKey: "2026-06-11", completedAt: Date())) { error in
            XCTAssertEqual(error as? WinRepositoryError, .winNotFound)
        }
    }

    func testGetWinsReturnsRangeInDateOrder() throws {
        try repository.upsertWin(dateKey: "2026-06-09", title: "Day 1", category: .custom)
        try repository.upsertWin(dateKey: "2026-06-11", title: "Day 3", category: .custom)
        try repository.upsertWin(dateKey: "2026-06-10", title: "Day 2", category: .custom)

        let wins = try repository.getWins(from: "2026-06-09", to: "2026-06-11")

        XCTAssertEqual(wins.map(\.dateKey), ["2026-06-09", "2026-06-10", "2026-06-11"])
    }

    func testGetAllWinsOnEmptyStoreReturnsEmptyArray() throws {
        XCTAssertTrue(try repository.getAllWins().isEmpty)
    }

    func testDeleteAllDataRemovesEverything() throws {
        try repository.upsertWin(dateKey: "2026-06-11", title: "Drink water", category: .health)
        try repository.upsertWin(dateKey: "2026-06-10", title: "Walk", category: .health)

        try repository.deleteAllData()

        XCTAssertTrue(try repository.getAllWins().isEmpty)
    }
}
