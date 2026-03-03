import SwiftUI

/// Placeholder mascot view — replace with final animated assets.
/// Uses SwiftUI Canvas to draw a simple friendly face that scales with its frame.
struct MascotView: View {

    enum MascotState {
        case idle
        case active
        case done
    }

    let state: MascotState

    var body: some View {
        Canvas { context, size in
            let w = size.width
            let h = size.height
            let cx = w / 2
            let cy = h / 2

            // Body
            context.fill(
                Path(roundedRect: CGRect(x: 0, y: 0, width: w, height: h), cornerRadius: w * 0.22),
                with: .color(.white)
            )

            // Eyes
            let eyeY = cy - h * 0.1
            let eyeR = w * 0.07
            let eyeSpacing = w * 0.16
            let eyeColor: GraphicsContext.Shading = .color(.black)
            context.fill(
                Path(ellipseIn: CGRect(x: cx - eyeSpacing - eyeR, y: eyeY - eyeR, width: eyeR * 2, height: eyeR * 2)),
                with: eyeColor
            )
            context.fill(
                Path(ellipseIn: CGRect(x: cx + eyeSpacing - eyeR, y: eyeY - eyeR, width: eyeR * 2, height: eyeR * 2)),
                with: eyeColor
            )

            // Mouth — wider smile when done, standard otherwise
            var mouth = Path()
            let mouthRadius = w * (state == .done ? 0.24 : 0.20)
            mouth.addArc(
                center: CGPoint(x: cx, y: cy + h * 0.06),
                radius: mouthRadius,
                startAngle: .degrees(20),
                endAngle: .degrees(160),
                clockwise: false
            )
            context.stroke(mouth, with: .color(.black), lineWidth: 2.5)
        }
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(.white)
                .shadow(color: .black.opacity(0.12), radius: 8, y: 3)
        )
    }
}

#Preview {
    HStack(spacing: 16) {
        MascotView(state: .idle).frame(width: 80, height: 80)
        MascotView(state: .active).frame(width: 80, height: 80)
        MascotView(state: .done).frame(width: 80, height: 80)
    }
    .padding()
}
