import Foundation

struct YearProgressCalculator {
    private var calendar: Calendar

    init(calendar: Calendar = YearProgressCalculator.defaultCalendar()) {
        self.calendar = calendar
    }

    private static func defaultCalendar() -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        let localCalendar = Calendar.autoupdatingCurrent

        calendar.locale = .autoupdatingCurrent
        calendar.timeZone = .autoupdatingCurrent
        calendar.firstWeekday = localCalendar.firstWeekday
        calendar.minimumDaysInFirstWeek = localCalendar.minimumDaysInFirstWeek

        return calendar
    }

    func snapshot(for date: Date) -> YearProgressSnapshot {
        let year = calendar.component(.year, from: date)
        let dayMonths = dayMonths(for: year, date: date)

        return YearProgressSnapshot(
            year: year,
            generatedAt: date,
            dayMonths: dayMonths,
            dayUnits: dayMonths.flatMap { $0.days },
            weekUnits: weekUnits(for: year, date: date),
            monthUnits: monthUnits(for: year, date: date),
            quarterUnits: quarterUnits(for: year, date: date)
        )
    }

    private func dayMonths(for year: Int, date: Date) -> [ProgressMonth] {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.dateFormat = "MMM"

        return (1...12).compactMap { month -> ProgressMonth? in
            guard
                let monthStart = calendar.date(from: DateComponents(year: year, month: month, day: 1)),
                let nextMonthStart = calendar.date(byAdding: .month, value: 1, to: monthStart),
                let numberOfDays = calendar.dateComponents([.day], from: monthStart, to: nextMonthStart).day
            else {
                return nil
            }

            let days = (1...numberOfDays).compactMap { day -> ProgressUnit? in
                guard
                    let start = calendar.date(from: DateComponents(year: year, month: month, day: day)),
                    let end = calendar.date(byAdding: .day, value: 1, to: start)
                else {
                    return nil
                }

                return ProgressUnit(
                    id: "day-\(month)-\(day)",
                    label: "\(day)",
                    accessibilityLabel: "\(formatter.monthSymbols[month - 1]) \(day)",
                    state: state(for: date, intervalStart: start, intervalEnd: end)
                )
            }

            return ProgressMonth(
                id: "month-days-\(month)",
                label: formatter.string(from: monthStart),
                days: days
            )
        }
    }

    private func weekUnits(for year: Int, date: Date) -> [ProgressUnit] {
        guard
            let yearStart = calendar.date(from: DateComponents(year: year, month: 1, day: 1)),
            let nextYearStart = calendar.date(from: DateComponents(year: year + 1, month: 1, day: 1))
        else {
            return []
        }

        var intervalStart = calendar.dateInterval(of: .weekOfYear, for: yearStart)?.start ?? yearStart
        var units: [ProgressUnit] = []
        var weekNumber = 1

        while intervalStart < nextYearStart {
            guard let intervalEnd = calendar.date(byAdding: .weekOfYear, value: 1, to: intervalStart) else {
                break
            }

            let clampedStart = max(intervalStart, yearStart)
            let clampedEnd = min(intervalEnd, nextYearStart)

            units.append(
                ProgressUnit(
                    id: "week-\(weekNumber)",
                    label: "\(weekNumber)",
                    accessibilityLabel: "Week \(weekNumber)",
                    state: state(for: date, intervalStart: clampedStart, intervalEnd: clampedEnd)
                )
            )

            intervalStart = intervalEnd
            weekNumber += 1
        }

        return units
    }

    private func monthUnits(for year: Int, date: Date) -> [ProgressUnit] {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.dateFormat = "MMM"

        return (1...12).compactMap { month in
            guard
                let start = calendar.date(from: DateComponents(year: year, month: month, day: 1)),
                let end = calendar.date(byAdding: .month, value: 1, to: start)
            else {
                return nil
            }

            let label = formatter.string(from: start)
            return ProgressUnit(
                id: "month-\(month)",
                label: label,
                accessibilityLabel: formatter.monthSymbols[month - 1],
                state: state(for: date, intervalStart: start, intervalEnd: end)
            )
        }
    }

    private func quarterUnits(for year: Int, date: Date) -> [ProgressUnit] {
        (1...4).compactMap { quarter in
            let startMonth = ((quarter - 1) * 3) + 1

            guard
                let start = calendar.date(from: DateComponents(year: year, month: startMonth, day: 1)),
                let end = calendar.date(byAdding: .month, value: 3, to: start)
            else {
                return nil
            }

            return ProgressUnit(
                id: "quarter-\(quarter)",
                label: "Q\(quarter)",
                accessibilityLabel: "Quarter \(quarter)",
                state: state(for: date, intervalStart: start, intervalEnd: end)
            )
        }
    }

    private func state(for date: Date, intervalStart: Date, intervalEnd: Date) -> ProgressUnit.State {
        if date >= intervalEnd {
            return .complete
        }

        if date < intervalStart {
            return .upcoming
        }

        let elapsed = date.timeIntervalSince(intervalStart)
        let duration = intervalEnd.timeIntervalSince(intervalStart)

        guard duration > 0 else {
            return .upcoming
        }

        return .current(elapsed / duration)
    }
}
