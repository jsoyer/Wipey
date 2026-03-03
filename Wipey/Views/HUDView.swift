import SwiftUI
import WipeyCore

/// Compact floating HUD shown when the session is active in input-only mode (no blackout).
/// Displayed in the bottom-right corner of the primary display.
struct HUDView: View {

    @Environment(SessionManager.self) private var session

    var body: some View {
        VStack(spacing: 3) {
            HStack(spacing: 10) {
                Image(systemName: "lock.fill")
                    .imageScale(.small)

                Text("app.name", comment: "App name shown in the compact HUD")
                    .fontWeight(.semibold)

                if session.config.isEnabled(.autoTimer) {
                    Text(verbatim: "•")
                        .foregroundStyle(.secondary)
                    Text(timerText)
                        .monospacedDigit()
                }
            }
            .font(.subheadline)

            if session.config.isEnabled(.holdKey) {
                Text("hud.exit.hint", comment: "Brief instruction to exit shown in the compact HUD")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }

    private var timerText: String {
        let s = session.secondsRemaining
        return String(format: "%02d:%02d", s / 60, s % 60)
    }
}
