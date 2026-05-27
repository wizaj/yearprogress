# YearProgress

YearProgress is a SwiftUI iOS app scaffold for visualizing progress through the current year.

The app supports four views:

- Day: one unit per day of the year.
- Week: one unit per local calendar week touched by the year.
- Month: one row per month, with the current month partially filled.
- Quarter: one row per quarter, with the current quarter partially filled.

The first scaffold intentionally excludes holiday references, seasonal labels, large percentage counters, and day-left/day-passed counters.

## Widget

The `YearProgressWidgetExtension` target adds a configurable WidgetKit widget. Long-press the widget and choose Edit Widget to switch between day, week, month, and quarter views.

The app and widget both use semantic SwiftUI colors so they adapt to light and dark mode.

## Open in Xcode

Open `YearProgress.xcodeproj`, select an iPhone simulator, and run the `YearProgress` scheme.
