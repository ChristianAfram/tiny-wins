import Foundation
import SwiftData

@Model
final class DailyWin {
    @Attribute(.unique) var dateKey: String
    var title: String
    var categoryRawValue: String
    var statusRawValue: String
    var completedAt: Date?
    var createdAt: Date
    var updatedAt: Date

    init(
        dateKey: String,
        title: String,
        category: WinCategory,
        status: WinStatus = .planned,
        completedAt: Date? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.dateKey = dateKey
        self.title = title
        self.categoryRawValue = category.rawValue
        self.statusRawValue = status.rawValue
        self.completedAt = completedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    var category: WinCategory {
        get { WinCategory(rawValue: categoryRawValue) ?? .custom }
        set { categoryRawValue = newValue.rawValue }
    }

    var status: WinStatus {
        get { WinStatus(rawValue: statusRawValue) ?? .planned }
        set { statusRawValue = newValue.rawValue }
    }
}
