import Foundation

enum WinCategory: String, Codable, CaseIterable, Identifiable {
    case health
    case focus
    case relationships
    case home
    case mindfulness
    case custom

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .health: return "Health"
        case .focus: return "Focus"
        case .relationships: return "Relationships"
        case .home: return "Home"
        case .mindfulness: return "Mindfulness"
        case .custom: return "Custom"
        }
    }

    var symbolName: String {
        switch self {
        case .health: return "heart.fill"
        case .focus: return "target"
        case .relationships: return "person.2.fill"
        case .home: return "house.fill"
        case .mindfulness: return "leaf.fill"
        case .custom: return "sparkles"
        }
    }
}
