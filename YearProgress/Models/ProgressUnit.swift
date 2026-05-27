import Foundation

struct ProgressUnit: Identifiable, Hashable {
    enum State: Hashable {
        case complete
        case current(Double)
        case upcoming
    }

    let id: String
    let label: String
    let accessibilityLabel: String
    let state: State

    var fractionComplete: Double {
        switch state {
        case .complete:
            1
        case .current(let fraction):
            min(max(fraction, 0), 1)
        case .upcoming:
            0
        }
    }
}

struct ProgressMonth: Identifiable, Hashable {
    let id: String
    let label: String
    let days: [ProgressUnit]
}

struct YearProgressSnapshot {
    let year: Int
    let generatedAt: Date
    let dayMonths: [ProgressMonth]
    let dayUnits: [ProgressUnit]
    let weekUnits: [ProgressUnit]
    let monthUnits: [ProgressUnit]
    let quarterUnits: [ProgressUnit]
}
