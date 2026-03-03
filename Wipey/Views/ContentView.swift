import SwiftUI
import AppKit
import WipeyCore

struct ContentView: View {

    @Environment(SessionManager.self) private var session
    @State private var remark = ""
    @State private var permissionError = false

    var body: some View {
        @Bindable var session = session

        VStack(spacing: 0) {
            header
            Divider()
            mascotSection
            Divider()
            toggleSection(session: $session)
            Divider()
            ctaSection
        }
        .frame(width: 380, height: 480)
        .background(WindowFloatingModifier())
        .onChange(of: session.config) { _, new in
            PreferencesManager.shared.sessionConfig = new
        }
        .onAppear {
            remark = Remarks.idle(style: PreferencesManager.shared.remarksStyle)
        }
        .alert(
            Text("permission.alert.title", comment: "Alert title when accessibility is denied"),
            isPresented: $permissionError
        ) {
            Button(String(localized: "permission.alert.open_settings", comment: "Button to open System Settings")) {
                let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
                NSWorkspace.shared.open(url)
            }
            Button(String(localized: "common.cancel", comment: "Cancel button"), role: .cancel) {}
        } message: {
            Text("permission.alert.message", comment: "Alert message explaining why accessibility is needed")
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Text("app.name", comment: "Application name shown in the window title")
                .font(.headline)
            Spacer()
            Button {
                NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
            } label: {
                Image(systemName: "gearshape")
                    .imageScale(.medium)
            }
            .buttonStyle(.plain)
            .help(String(localized: "header.settings.tooltip", comment: "Settings button tooltip"))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    // MARK: - Mascot

    private var mascotSection: some View {
        VStack(spacing: 12) {
            MascotView(state: .idle)
                .frame(width: 100, height: 100)

            if !remark.isEmpty {
                Text(remark)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
    }

    // MARK: - Toggles
    // Takes an explicit @Bindable session binding to avoid creating a second
    // @Bindable wrapper for the same object inside a nested computed property.

    @ViewBuilder
    private func toggleSection(session: Bindable<SessionManager>) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("section.what_to_clean", comment: "Section label asking the user what to clean")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 16)
                .padding(.bottom, 8)

            LockToggleRow(
                icon: "keyboard",
                label: Text("toggle.keyboard", comment: "Toggle for locking keyboard and trackpad"),
                isOn: session.config.lockKeyboard
            )
            LockToggleRow(
                icon: "computermouse",
                label: Text("toggle.mouse", comment: "Toggle for locking mouse"),
                isOn: session.config.lockTrackpad
            )
            LockToggleRow(
                icon: "rectangle.on.rectangle.slash",
                label: Text("toggle.screen", comment: "Toggle for screen blackout"),
                isOn: session.config.blackoutScreen
            )
        }
        .padding(.vertical, 16)
    }

    // MARK: - CTA

    private var ctaSection: some View {
        VStack(spacing: 8) {
            Button {
                startSession()
            } label: {
                Text("session.start.button", comment: "CTA to start a cleaning session")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal, 16)
            .disabled(session.state.isActive)

            exitMethodSummary
        }
        .padding(.vertical, 16)
    }

    private var exitMethodSummary: some View {
        HStack(spacing: 6) {
            if session.config.isEnabled(.autoTimer) {
                Text(verbatim: "\(Int(session.config.timerDuration))s")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                Text(verbatim: "•").foregroundStyle(.quinary)
            }
            if session.config.isEnabled(.holdKey) {
                Text("exit.hint.hold_esc", comment: "Short label indicating hold-Esc exit")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                Text(verbatim: "•").foregroundStyle(.quinary)
            }
            if session.config.isEnabled(.touchID) {
                Text("exit.hint.touch_id", comment: "Short label indicating Touch ID exit")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
    }

    // MARK: - Actions

    private func startSession() {
        do {
            try session.startSession()
        } catch InputBlockerError.accessibilityPermissionDenied {
            permissionError = true
        } catch {
            // tapCreationFailed or unknown — session remains idle
        }
    }
}

// MARK: - LockToggleRow

private struct LockToggleRow: View {
    let icon: String
    let label: Text
    @Binding var isOn: Bool

    var body: some View {
        Toggle(isOn: $isOn) {
            Label { label } icon: {
                Image(systemName: icon)
                    .frame(width: 20)
            }
        }
        .toggleStyle(.switch)
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
    }
}

// MARK: - Window level helper (keeps main window always floating above others)

private final class FloatingWindowSetter: NSView {
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        window?.level = .floating
    }
}

private struct WindowFloatingModifier: NSViewRepresentable {
    func makeNSView(context: Context) -> FloatingWindowSetter { FloatingWindowSetter() }
    func updateNSView(_ nsView: FloatingWindowSetter, context: Context) {}
}
