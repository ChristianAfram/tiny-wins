import Foundation

struct TinyWinSuggestion: Identifiable, Hashable {
    let id: String
    let title: String
    let category: WinCategory
}

/// Static suggestion list for the MVP.
///
/// AI-generated suggestions are intentionally avoided in the MVP because
/// they introduce privacy, cost, safety, prompt-injection, and moderation
/// concerns.
struct SuggestionService {
    let suggestions: [TinyWinSuggestion] = [
        .init(id: "health-water", title: "Drink a glass of water", category: .health),
        .init(id: "health-walk", title: "Walk for 5 minutes", category: .health),
        .init(id: "focus-read-page", title: "Read one page", category: .focus),
        .init(id: "relationships-text", title: "Text someone you care about", category: .relationships),
        .init(id: "home-desk", title: "Clear one small surface", category: .home),
        .init(id: "mindfulness-breathe", title: "Take 5 slow breaths", category: .mindfulness)
    ]

    func suggestions(for category: WinCategory?) -> [TinyWinSuggestion] {
        guard let category else { return suggestions }
        return suggestions.filter { $0.category == category }
    }
}
