import SwiftUI
import WipeyCore

/// Shown in the HUD window above the blackout screen during an active session.
struct SessionView: View {

    @Environment(SessionManager.self) private var session
    @State private var remark = ""

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {
                MascotView(state: .active)
                    .frame(width: 100, height: 100)

                if !remark.isEmpty {
                    Text(remark)
                        .font(.title3)
                        .foregroundStyle(.white.opacity(0.75))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }

                if session.config.isEnabled(.autoTimer) {
                    Text(timerText)
                        .font(.system(size: 48, weight: .thin, design: .rounded))
                        .foregroundStyle(.white)
                        .monospacedDigit()
                }

                exitHint
            }
        }
        .onAppear {
            remark = Remarks.active(style: PreferencesManager.shared.remarksStyle)
        }
    }

    // MARK: - Timer display

    private var timerText: String {
        let s = session.secondsRemaining
        return String(format: "%02d:%02d", s / 60, s % 60)
    }

    // MARK: - Exit hint

    private var exitHint: some View {
        Group {
            if session.config.isEnabled(.holdKey) {
                Text("session.exit.hint.hold_key", comment: "Instruction to hold Esc key to exit")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.35))
            } else if session.config.isEnabled(.autoTimer) {
                Text("session.exit.hint.timer", comment: "Instruction that session ends automatically")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.35))
            }
        }
    }
}
