import Foundation

/// Tracks the lifecycle of a single day's tiny win.
///
/// `planned` and `missed` are distinguished (rather than a single
/// `isCompleted: Bool`) so history, streaks, and future analytics can tell
/// "chose a win but didn't finish it" apart from "day passed with no win"
/// without a future schema rewrite.
enum WinStatus: String, Codable {
    case planned
    case completed
    case missed
}
