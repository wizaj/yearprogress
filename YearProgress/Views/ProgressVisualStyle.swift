import SwiftUI

enum ProgressVisualStyle {
    static let complete = Color.green
    static let current = Color.mint
    static let upcoming = Color.secondary.opacity(0.16)
    static let currentStroke = Color.primary.opacity(0.36)
    static let trackStart = Color.secondary.opacity(0.14)
    static let trackEnd = Color.secondary.opacity(0.24)

    static var fillGradient: LinearGradient {
        LinearGradient(
            colors: [current, complete],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    static var trackGradient: LinearGradient {
        LinearGradient(
            colors: [trackStart, trackEnd],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    static func color(for unit: ProgressUnit?) -> Color {
        guard let unit else {
            return .clear
        }

        switch unit.state {
        case .complete:
            return complete
        case .current:
            return current
        case .upcoming:
            return upcoming
        }
    }
}
