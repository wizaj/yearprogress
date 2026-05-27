import SwiftUI

struct YearProgressDashboard: View {
    @Binding var selectedMode: ProgressMode
    let snapshot: YearProgressSnapshot

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header
                modePicker
                activeProgressView
            }
            .padding(20)
        }
        .background(.background)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(verbatim: "\(snapshot.year) Progress")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))

            Text(selectedMode.unitDescription)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var modePicker: some View {
        Picker("Progress mode", selection: $selectedMode) {
            ForEach(ProgressMode.allCases) { mode in
                Text(mode.rawValue).tag(mode)
            }
        }
        .pickerStyle(.segmented)
    }

    @ViewBuilder
    private var activeProgressView: some View {
        switch selectedMode {
        case .day:
            DayYearGridView(title: selectedMode.title, months: snapshot.dayMonths)
        case .week:
            UnitGridProgressView(title: selectedMode.title, units: snapshot.weekUnits, columns: 13)
        case .month:
            LinearProgressListView(title: selectedMode.title, units: snapshot.monthUnits)
        case .quarter:
            LinearProgressListView(title: selectedMode.title, units: snapshot.quarterUnits)
        }
    }
}

struct YearProgressDashboard_Previews: PreviewProvider {
    static var previews: some View {
        YearProgressDashboard(
            selectedMode: .constant(.quarter),
            snapshot: YearProgressCalculator().snapshot(for: Date())
        )
    }
}
