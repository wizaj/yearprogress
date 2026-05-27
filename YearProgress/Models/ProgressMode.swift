import Foundation

enum ProgressMode: String, CaseIterable, Identifiable {
    case day = "Day"
    case week = "Week"
    case month = "Month"
    case quarter = "Quarter"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .day:
            "Days"
        case .week:
            "Weeks"
        case .month:
            "Months"
        case .quarter:
            "Quarters"
        }
    }
}
