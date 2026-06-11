import XCTest
@testable import TinyWins

final class SuggestionServiceTests: XCTestCase {
    func testReturnsAllSuggestionsWhenCategoryIsNil() {
        let service = SuggestionService()

        XCTAssertEqual(service.suggestions(for: nil).count, service.suggestions.count)
    }

    func testFiltersSuggestionsByCategory() {
        let service = SuggestionService()

        let healthSuggestions = service.suggestions(for: .health)

        XCTAssertFalse(healthSuggestions.isEmpty)
        XCTAssertTrue(healthSuggestions.allSatisfy { $0.category == .health })
    }

    func testSuggestionIdsAreUnique() {
        let service = SuggestionService()
        let ids = service.suggestions.map(\.id)

        XCTAssertEqual(ids.count, Set(ids).count)
    }
}
