import SwiftUI

enum ProgressVisualStyle {
    static let complete = Color.green
    static let current = Color.green
    static let upcoming = Color.secondary.opacity(0.16)
    static let currentStroke = Color.primary.opacity(0.36)

    static let trackFill = Color.primary.opacity(0.12)
    static let fillColor = Color.green

    static var fillGradient: LinearGradient {
        LinearGradient(
            colors: [current, complete],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    static var trackGradient: LinearGradient {
        LinearGradient(
            colors: [trackFill, trackFill],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    static let stripeColor = Color.white.opacity(0.18)

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

struct DiagonalStripes: View {
    var spacing: CGFloat = 8
    var lineWidth: CGFloat = 3
    var color: Color = ProgressVisualStyle.stripeColor

    var body: some View {
        Canvas { context, size in
            var x: CGFloat = -size.height
            while x <= size.width {
                var path = Path()
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x + size.height, y: size.height))
                context.stroke(path, with: .color(color), lineWidth: lineWidth)
                x += spacing
            }
        }
    }
}
