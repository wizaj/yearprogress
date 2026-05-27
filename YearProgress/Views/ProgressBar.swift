import SwiftUI

struct ProgressBar: View {
    let fraction: Double

    private var clampedFraction: Double {
        min(max(fraction, 0), 1)
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule(style: .continuous)
                    .fill(ProgressVisualStyle.trackFill)

                Capsule(style: .continuous)
                    .fill(ProgressVisualStyle.fillColor)
                    .frame(width: proxy.size.width * clampedFraction)

                DiagonalStripes()
                    .allowsHitTesting(false)
            }
        }
        .clipShape(Capsule(style: .continuous))
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 14) {
            ProgressBar(fraction: 1.0)
            ProgressBar(fraction: 0.6)
            ProgressBar(fraction: 0)
        }
        .frame(height: 28)
        .padding()
        .background(Color.black)
        .preferredColorScheme(.dark)
    }
}
