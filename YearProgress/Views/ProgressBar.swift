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
                    .fill(trackStyle)

                Capsule(style: .continuous)
                    .fill(fillStyle)
                    .frame(width: proxy.size.width * clampedFraction)
            }
        }
        .clipShape(Capsule(style: .continuous))
    }

    private var trackStyle: LinearGradient {
        ProgressVisualStyle.trackGradient
    }

    private var fillStyle: LinearGradient {
        ProgressVisualStyle.fillGradient
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(fraction: 0.42)
            .frame(height: 18)
            .padding()
    }
}
