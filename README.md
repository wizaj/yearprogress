# YearProgress

YearProgress is a small SwiftUI app for seeing where you are in the year without turning the calendar into a productivity scoreboard.

It shows the current year as a calm visual timeline: days, weeks, months, or quarters. Completed time is filled in, future time stays quiet, and the current unit is highlighted so you can read the year at a glance from the app or from a Home Screen widget.

## Why this exists

Most year-progress tools lean on big percentages, countdowns, or motivational pressure. YearProgress takes the opposite approach. It is meant to be glanceable, neutral, and useful: a visual sense of time passing without telling you what that time should mean.

## Features

- **Four progress views**: switch between day, week, month, and quarter views.
- **Day grid**: each month is shown as a row of day cells, making leap years and month lengths visible.
- **Week grid**: weeks follow the user's local calendar settings, including first weekday rules.
- **Month and quarter bars**: larger units show partial progress within the active period.
- **WidgetKit support**: add Year Progress to the Home Screen in small, medium, or large sizes.
- **Configurable widget**: choose the widget view and set appearance to Auto, Light, or Dark.
- **Adaptive colors**: the app uses semantic SwiftUI colors for light and dark mode.
- **Accessibility labels**: progress units expose readable labels and percentage values to assistive technologies.

## Screens

The app opens to the current year with a segmented control for changing the visualization:

- **Day**: one cell per day, grouped by month.
- **Week**: one cell per local calendar week touched by the year.
- **Month**: one progress bar per month.
- **Quarter**: one progress bar per quarter.

The widget uses the same calendar model and refreshes periodically so the display stays current throughout the day.

## Requirements

- Xcode 15 or newer
- iOS 17 or newer
- SwiftUI and WidgetKit

## Run Locally

1. Open `YearProgress.xcodeproj` in Xcode.
2. Select the `YearProgress` scheme.
3. Choose an iPhone simulator or connected device.
4. Build and run.

To try the widget, run the app once, then add the **Year Progress** widget from the iOS Home Screen widget picker. Long-press the widget and choose **Edit Widget** to switch between day, week, month, and quarter views.

## Project Structure

- `YearProgress/` contains the SwiftUI app, models, views, and calendar calculation logic.
- `YearProgressWidget/` contains the WidgetKit extension and widget configuration intent.
- `Assets/` contains public image assets for the project.
- `YearProgress.xcodeproj/` contains the Xcode project and shared scheme.

## Design Notes

YearProgress intentionally avoids holiday labels, seasonal language, large counters, and "days left" messaging. The focus is the shape of the year itself: what has passed, what is happening now, and what remains.

Calendar calculations use the user's autoupdating Gregorian calendar settings, including locale, time zone, first weekday, and minimum days in the first week. That keeps the week view aligned with the way the device already presents dates.

