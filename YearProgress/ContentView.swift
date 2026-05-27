import SwiftUI

struct ContentView: View {
    @State private var selectedMode: ProgressMode = .quarter
    private let calculator = YearProgressCalculator()

    var body: some View {
        NavigationStack {
            YearProgressDashboard(
                selectedMode: $selectedMode,
                snapshot: calculator.snapshot(for: Date())
            )
            .navigationTitle("Year Progress")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
