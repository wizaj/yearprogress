import SwiftUI

struct DayYearGridView: View {
    let title: String
    let months: [ProgressMonth]

    private let labelWidth: CGFloat = 34
    private let cellSpacing: CGFloat = 3

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.headline)

            VStack(alignment: .leading, spacing: 5) {
                ForEach(months) { month in
                    HStack(spacing: cellSpacing) {
                        Text(month.label)
                            .font(.system(.caption2, design: .rounded, weight: .semibold))
                            .foregroundStyle(.secondary)
                            .frame(width: labelWidth, alignment: .leading)

                        ForEach(0..<31, id: \.self) { index in
                            if index < month.days.count {
                                DayCell(unit: month.days[index])
                            } else {
                                DayCell(unit: nil)
                            }
                        }
                    }
                    .frame(maxWidth: labelWidth + 31 * 10 + 30 * cellSpacing, alignment: .leading)
                }
            }
        }
    }
}

private struct DayCell: View {
    let unit: ProgressUnit?

    var body: some View {
        RoundedRectangle(cornerRadius: 2.5, style: .continuous)
            .fill(fill)
            .aspectRatio(1, contentMode: .fit)
            .frame(maxWidth: 10)
            .overlay {
                if let unit, case .current = unit.state {
                    RoundedRectangle(cornerRadius: 2.5, style: .continuous)
                        .stroke(ProgressVisualStyle.currentStroke, lineWidth: 1)
                }
            }
            .accessibilityHidden(unit == nil)
            .accessibilityLabel(unit?.accessibilityLabel ?? "")
            .accessibilityValue(accessibilityValue)
    }

    private var fill: Color {
        ProgressVisualStyle.color(for: unit)
    }

    private var accessibilityValue: String {
        guard let unit else {
            return ""
        }

        return "\(Int((unit.fractionComplete * 100).rounded())) percent complete"
    }
}

struct DayYearGridView_Previews: PreviewProvider {
    static var previews: some View {
        DayYearGridView(
            title: "Days",
            months: YearProgressCalculator().snapshot(for: Date()).dayMonths
        )
        .padding()
    }
}
