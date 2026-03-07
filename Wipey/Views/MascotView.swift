import SwiftUI

// MARK: - Brand colors

extension Color {
    static let wipeyBlue = Color(red: 0.231, green: 0.510, blue: 0.965) // #3B82F6
    static let wipeyCyan = Color(red: 0.024, green: 0.714, blue: 0.831) // #06B6D4
    static let wipeyDark = Color(red: 0.059, green: 0.090, blue: 0.165) // #0F172A
}

// MARK: - MascotView

struct MascotView: View {

    enum MascotState { case idle, active, done }

    let state: MascotState

    @State private var breathScale: CGFloat = 1.0
    @State private var eyeOpenness: CGFloat = 1.0
    @State private var wipeOffset: CGFloat = 0.0
    @State private var jumpOffset: CGFloat = 0.0
    @State private var sparkleOpacity: Double = 0.0
    @State private var sparkleScale: CGFloat = 0.6

    private let blinkPublisher = Timer.publish(every: 5, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            if state == .active {
                trailView.allowsHitTesting(false)
            }

            mascotCanvas
                .scaleEffect(breathScale)
                .offset(x: wipeOffset, y: jumpOffset)

            if state == .done {
                sparkleView
                    .opacity(sparkleOpacity)
                    .scaleEffect(sparkleScale)
                    .allowsHitTesting(false)
            }
        }
        .shadow(color: .black.opacity(0.14), radius: 8, x: 0, y: 3)
        .onReceive(blinkPublisher) { _ in
            guard state == .idle else { return }
            blink()
        }
        .onAppear { startAnimations(for: state) }
        .onChange(of: state) { _, newState in startAnimations(for: newState) }
    }

    // MARK: - Mascot canvas

    private var mascotCanvas: some View {
        Canvas { context, size in
            let w = size.width
            let h = size.height
            let cx = w / 2
            let cy = h / 2

            let bodyRect = CGRect(x: 1.5, y: 1.5, width: w - 3, height: h - 3)
            let corner = w * 0.22
            let body = Path(roundedRect: bodyRect, cornerRadius: corner)

            // Body fill
            context.fill(body, with: .color(.white))

            // Microfiber dot texture (clipped to body)
            var texCtx = context
            texCtx.clip(to: body)
            let step = w * 0.135
            var dotY = step * 0.5
            while dotY < h {
                var dotX = step * 0.5
                while dotX < w {
                    let dot = CGRect(x: dotX - 0.8, y: dotY - 0.8, width: 1.6, height: 1.6)
                    texCtx.fill(Path(ellipseIn: dot), with: .color(Color(white: 0.87)))
                    dotX += step
                }
                dotY += step
            }

            // Border
            context.stroke(body, with: .color(Color(white: 0.80)), style: StrokeStyle(lineWidth: 1))

            // Eyes
            let eyeBaseY = cy - h * 0.11
            let eyeR = w * 0.075
            let eyeSpacing = w * 0.17
            let eyeH = eyeR * 2 * eyeOpenness
            let eyeYShift = eyeR * (1 - eyeOpenness)

            for sign: CGFloat in [-1, 1] {
                let ex = cx + sign * eyeSpacing - eyeR
                context.fill(
                    Path(ellipseIn: CGRect(x: ex, y: eyeBaseY - eyeR + eyeYShift, width: eyeR * 2, height: eyeH)),
                    with: .color(Color(white: 0.08))
                )
            }

            // Cheeks
            let cheekR = w * 0.095
            let cheekY = eyeBaseY + eyeR * 2.8
            for sign: CGFloat in [-1, 1] {
                let chx = cx + sign * eyeSpacing * 1.75 - cheekR
                context.fill(
                    Path(ellipseIn: CGRect(x: chx, y: cheekY - cheekR, width: cheekR * 2, height: cheekR * 2)),
                    with: .color(Color(red: 1.0, green: 0.72, blue: 0.78, opacity: 0.45))
                )
            }

            // Mouth
            let mouthRadius = w * (state == .done ? 0.25 : 0.18)
            let mouthCY = cy + h * 0.15
            var mouth = Path()
            mouth.addArc(
                center: CGPoint(x: cx, y: mouthCY),
                radius: mouthRadius,
                startAngle: .degrees(15),
                endAngle: .degrees(165),
                clockwise: false
            )
            context.stroke(
                mouth,
                with: .color(Color(white: 0.12)),
                style: StrokeStyle(lineWidth: 2.5, lineCap: .round)
            )
        }
    }

    // MARK: - Trail (active state)

    private var trailView: some View {
        Canvas { context, size in
            let w = size.width
            let h = size.height
            var trail = Path()
            trail.move(to: CGPoint(x: w * 0.05, y: h * 0.52))
            trail.addQuadCurve(
                to: CGPoint(x: w * 0.95, y: h * 0.48),
                control: CGPoint(x: w * 0.5, y: h * 0.38)
            )
            context.stroke(
                trail,
                with: .linearGradient(
                    Gradient(colors: [
                        Color.wipeyCyan.opacity(0),
                        Color.wipeyCyan.opacity(0.65),
                        Color.wipeyBlue.opacity(0.3),
                    ]),
                    startPoint: CGPoint(x: 0, y: h * 0.5),
                    endPoint: CGPoint(x: w, y: h * 0.5)
                ),
                style: StrokeStyle(lineWidth: 3.5, lineCap: .round)
            )
        }
    }

    // MARK: - Sparkle (done state)

    private var sparkleView: some View {
        Canvas { context, size in
            let w = size.width
            let h = size.height
            let positions: [(CGFloat, CGFloat, CGFloat)] = [
                (0.10, 0.08, 0.11),
                (0.88, 0.12, 0.09),
                (0.08, 0.88, 0.08),
                (0.90, 0.86, 0.10),
            ]
            for (rx, ry, rs) in positions {
                drawStar(context: context, at: CGPoint(x: w * rx, y: h * ry), size: w * rs)
            }
        }
    }

    private func drawStar(context: GraphicsContext, at center: CGPoint, size: CGFloat) {
        let half = size / 2
        let thin = half * 0.22
        let pts: [(CGFloat, CGFloat)] = [
            (0, -half), (thin, -thin),
            (half, 0), (thin, thin),
            (0, half), (-thin, thin),
            (-half, 0), (-thin, -thin),
        ]
        var star = Path()
        star.move(to: CGPoint(x: center.x + pts[0].0, y: center.y + pts[0].1))
        for pt in pts.dropFirst() {
            star.addLine(to: CGPoint(x: center.x + pt.0, y: center.y + pt.1))
        }
        star.closeSubpath()
        context.fill(star, with: .color(Color.wipeyCyan))
    }

    // MARK: - Animations

    private func startAnimations(for state: MascotState) {
        wipeOffset = 0
        jumpOffset = 0
        sparkleOpacity = 0
        sparkleScale = 0.6
        breathScale = 1.0
        eyeOpenness = 1.0

        switch state {
        case .idle:
            withAnimation(.easeInOut(duration: 2.8).repeatForever(autoreverses: true)) {
                breathScale = 1.04
            }
        case .active:
            wipeOffset = -10
            withAnimation(.easeInOut(duration: 1.1).repeatForever(autoreverses: true)) {
                wipeOffset = 10
            }
        case .done:
            withAnimation(.spring(response: 0.32, dampingFraction: 0.45)) {
                jumpOffset = -16
            }
            withAnimation(.easeIn(duration: 0.55).delay(0.25)) {
                sparkleOpacity = 1
                sparkleScale = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                withAnimation(.easeOut(duration: 0.45)) {
                    jumpOffset = 0
                }
            }
        }
    }

    private func blink() {
        withAnimation(.easeInOut(duration: 0.1)) { eyeOpenness = 0.08 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeInOut(duration: 0.1)) { eyeOpenness = 1.0 }
        }
    }
}

// MARK: - Preview

#Preview {
    HStack(spacing: 20) {
        MascotView(state: .idle).frame(width: 90, height: 90)
        MascotView(state: .active).frame(width: 90, height: 90)
        MascotView(state: .done).frame(width: 90, height: 90)
    }
    .padding(24)
    .background(Color(white: 0.95))
}
