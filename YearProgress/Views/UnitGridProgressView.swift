import SwiftUI

struct UnitGridProgressView: View {
    let title: String
    let units: [ProgressUnit]
    let columns: Int

    private var gridColumns: [GridItem] {
        Array(
            repeating: GridItem(.flexible(minimum: 10), spacing: 6),
            count: columns
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.headline)

            LazyVGrid(columns: gridColumns, alignment: .leading, spacing: 6) {
                ForEach(units) { unit in
                    UnitCell(unit: unit)
                }
            }
        }
    }
}

private struct UnitCell: View {
    let unit: ProgressUnit

    var body: some View {
        RoundedRectangle(cornerRadius: 4, style: .continuous)
            .fill(fill)
            .aspectRatio(1, contentMode: .fit)
            .overlay(alignment: .bottom) {
                if case .current = unit.state {
                    Capsule(style: .continuous)
                        .fill(ProgressVisualStyle.currentStroke)
                        .frame(height: 3)
                        .padding(.horizontal, 3)
                        .padding(.bottom, 3)
                }
            }
            .accessibilityLabel(unit.accessibilityLabel)
            .accessibilityValue("\(Int((unit.fractionComplete * 100).rounded())) percent complete")
    }

    private var fill: Color {
        ProgressVisualStyle.color(for: unit)
    }
}

struct UnitGridProgressView_Previews: PreviewProvider {
    static var previews: some View {
        UnitGridProgressView(
            title: "Weeks",
            units: YearProgressCalculator().snapshot(for: Date()).weekUnits,
            columns: 13
        )
        .padding()
    }
}
