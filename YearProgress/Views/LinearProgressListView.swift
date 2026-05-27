import SwiftUI

struct LinearProgressListView: View {
    let title: String
    let units: [ProgressUnit]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.headline)

            VStack(spacing: 14) {
                ForEach(units) { unit in
                    HStack(spacing: 14) {
                        Text(unit.label)
                            .font(.system(.body, design: .rounded, weight: .semibold))
                            .foregroundStyle(.primary)
                            .frame(width: 44, alignment: .leading)

                        ProgressBar(fraction: unit.fractionComplete)
                            .frame(height: 18)
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(unit.accessibilityLabel)
                    .accessibilityValue(accessibilityValue(for: unit))
                }
            }
        }
    }

    private func accessibilityValue(for unit: ProgressUnit) -> String {
        let percent = Int((unit.fractionComplete * 100).rounded())
        return "\(percent) percent complete"
    }
}

struct LinearProgressListView_Previews: PreviewProvider {
    static var previews: some View {
        LinearProgressListView(
            title: "Quarters",
            units: YearProgressCalculator().snapshot(for: Date()).quarterUnits
        )
        .padding()
    }
}
