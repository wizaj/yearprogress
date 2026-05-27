import AppIntents
import SwiftUI
import WidgetKit

enum YearProgressWidgetMode: String, AppEnum {
    case day
    case week
    case month
    case quarter

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Progress View"

    static var caseDisplayRepresentations: [YearProgressWidgetMode: DisplayRepresentation] = [
        .day: "Day",
        .week: "Week",
        .month: "Month",
        .quarter: "Quarter"
    ]

    var progressMode: ProgressMode {
        switch self {
        case .day:
            return .day
        case .week:
            return .week
        case .month:
            return .month
        case .quarter:
            return .quarter
        }
    }
}

struct YearProgressWidgetConfiguration: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Year Progress"
    static var description = IntentDescription("Choose the progress view shown by the widget.")

    @Parameter(title: "View")
    var mode: YearProgressWidgetMode

    init() {
        mode = .quarter
    }
}

struct YearProgressWidgetEntry: TimelineEntry {
    let date: Date
    let snapshot: YearProgressSnapshot
    let mode: YearProgressWidgetMode
}

struct YearProgressWidgetProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> YearProgressWidgetEntry {
        entry(for: Date(), mode: .quarter)
    }

    func snapshot(for configuration: YearProgressWidgetConfiguration, in context: Context) async -> YearProgressWidgetEntry {
        entry(for: Date(), mode: configuration.mode)
    }

    func timeline(for configuration: YearProgressWidgetConfiguration, in context: Context) async -> Timeline<YearProgressWidgetEntry> {
        let now = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 30, to: now) ?? now.addingTimeInterval(1800)

        return Timeline(
            entries: [entry(for: now, mode: configuration.mode)],
            policy: .after(refreshDate)
        )
    }

    private func entry(for date: Date, mode: YearProgressWidgetMode) -> YearProgressWidgetEntry {
        YearProgressWidgetEntry(
            date: date,
            snapshot: YearProgressCalculator().snapshot(for: date),
            mode: mode
        )
    }
}

struct YearProgressWidget: Widget {
    let kind = "YearProgressWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: YearProgressWidgetConfiguration.self,
            provider: YearProgressWidgetProvider()
        ) { entry in
            YearProgressWidgetView(entry: entry)
                .containerBackground(.background, for: .widget)
        }
        .configurationDisplayName("Year Progress")
        .description("Track the year by day, week, month, or quarter.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

private struct YearProgressWidgetView: View {
    @Environment(\.widgetFamily) private var family

    let entry: YearProgressWidgetEntry

    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            header

            switch family {
            case .systemSmall:
                smallContent
            case .systemLarge:
                largeContent
            default:
                mediumContent
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(verbatim: "\(entry.snapshot.year) Progress")
                .font(.system(.headline, design: .rounded, weight: .bold))
                .lineLimit(1)
                .minimumScaleFactor(0.82)

            Text(entry.mode.progressMode.title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var smallContent: some View {
        switch entry.mode {
        case .quarter:
            WidgetLinearBars(units: entry.snapshot.quarterUnits, labelWidth: 18, barHeight: 8)
        case .month:
            WidgetUnitGrid(units: entry.snapshot.monthUnits, columns: 4, cornerRadius: 4)
        case .week:
            WidgetUnitGrid(units: entry.snapshot.weekUnits, columns: 8, cornerRadius: 2.5)
        case .day:
            WidgetMonthDayGrid(months: entry.snapshot.dayMonths, compact: true)
        }
    }

    @ViewBuilder
    private var mediumContent: some View {
        switch entry.mode {
        case .quarter:
            WidgetLinearBars(units: entry.snapshot.quarterUnits, labelWidth: 22, barHeight: 10)
        case .month:
            WidgetLinearBars(units: entry.snapshot.monthUnits, labelWidth: 28, barHeight: 8)
        case .week:
            WidgetUnitGrid(units: entry.snapshot.weekUnits, columns: 13, cornerRadius: 3)
        case .day:
            WidgetMonthDayGrid(months: entry.snapshot.dayMonths, compact: true)
        }
    }

    @ViewBuilder
    private var largeContent: some View {
        switch entry.mode {
        case .quarter:
            WidgetLinearBars(units: entry.snapshot.quarterUnits, labelWidth: 24, barHeight: 14)
        case .month:
            WidgetLinearBars(units: entry.snapshot.monthUnits, labelWidth: 34, barHeight: 10)
        case .week:
            WidgetUnitGrid(units: entry.snapshot.weekUnits, columns: 13, cornerRadius: 4)
        case .day:
            WidgetMonthDayGrid(months: entry.snapshot.dayMonths, compact: false)
        }
    }

    private var spacing: CGFloat {
        family == .systemSmall ? 10 : 14
    }
}

private struct WidgetLinearBars: View {
    let units: [ProgressUnit]
    let labelWidth: CGFloat
    let barHeight: CGFloat

    var body: some View {
        VStack(spacing: 7) {
            ForEach(units) { unit in
                HStack(spacing: 8) {
                    Text(unit.label)
                        .font(.system(.caption2, design: .rounded, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .frame(width: labelWidth, alignment: .leading)

                    WidgetProgressBar(fraction: unit.fractionComplete)
                        .frame(height: barHeight)
                }
            }
        }
    }
}

private struct WidgetProgressBar: View {
    let fraction: Double

    private var clampedFraction: Double {
        min(max(fraction, 0), 1)
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule(style: .continuous)
                    .fill(ProgressVisualStyle.trackGradient)

                Capsule(style: .continuous)
                    .fill(ProgressVisualStyle.fillGradient)
                    .frame(width: proxy.size.width * clampedFraction)
            }
        }
        .clipShape(Capsule(style: .continuous))
    }
}

private struct WidgetUnitGrid: View {
    let units: [ProgressUnit]
    let columns: Int
    let cornerRadius: CGFloat

    private var gridColumns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 4), count: columns)
    }

    var body: some View {
        LazyVGrid(columns: gridColumns, spacing: 4) {
            ForEach(units) { unit in
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(ProgressVisualStyle.color(for: unit))
                    .aspectRatio(1, contentMode: .fit)
                    .overlay {
                        if case .current = unit.state {
                            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                                .stroke(ProgressVisualStyle.currentStroke, lineWidth: 1)
                        }
                    }
                    .accessibilityLabel(unit.accessibilityLabel)
                    .accessibilityValue("\(Int((unit.fractionComplete * 100).rounded())) percent complete")
            }
        }
    }
}

private struct WidgetMonthDayGrid: View {
    let months: [ProgressMonth]
    let compact: Bool

    private var cellSpacing: CGFloat {
        compact ? 2 : 3
    }

    private var labelWidth: CGFloat {
        compact ? 0 : 30
    }

    var body: some View {
        VStack(alignment: .leading, spacing: compact ? 3 : 5) {
            ForEach(months) { month in
                HStack(spacing: cellSpacing) {
                    if !compact {
                        Text(month.label)
                            .font(.system(.caption2, design: .rounded, weight: .semibold))
                            .foregroundStyle(.secondary)
                            .frame(width: labelWidth, alignment: .leading)
                    }

                    ForEach(0..<31, id: \.self) { index in
                        RoundedRectangle(cornerRadius: compact ? 1.5 : 2, style: .continuous)
                            .fill(index < month.days.count ? ProgressVisualStyle.color(for: month.days[index]) : .clear)
                            .aspectRatio(1, contentMode: .fit)
                    }
                }
            }
        }
    }
}

struct YearProgressWidget_Previews: PreviewProvider {
    static var previews: some View {
        YearProgressWidgetView(
            entry: YearProgressWidgetEntry(
                date: Date(),
                snapshot: YearProgressCalculator().snapshot(for: Date()),
                mode: .quarter
            )
        )
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
