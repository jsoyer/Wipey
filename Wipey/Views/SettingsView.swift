import SwiftUI
import WipeyCore

struct SettingsView: View {

    @Environment(SessionManager.self) private var session

    // Local state — loaded from PreferencesManager on appear, saved on change
    @State private var config: SessionConfig = .init()
    @State private var remarksStyle: PreferencesManager.RemarksStyle = .sarcastic
    @State private var launchAtLogin = false
    @State private var showInMenuBar = true
    @State private var menuBarOnly = false
    @State private var telemetryOptIn = false

    private static let timerValues: [TimeInterval] = [15, 30, 60, 90, 120, 180, 300]
    private static let holdDurations: [TimeInterval] = [1, 2, 3, 5, 8]
    private static let sequenceCounts: [Int] = [3, 4, 5, 7, 10]

    var body: some View {
        Form {
            exitMechanismsSection
            behaviorSection
            remarksSection
            privacySection
            aboutSection
        }
        .formStyle(.grouped)
        .frame(width: 440)
        .fixedSize(horizontal: false, vertical: true)
        .onAppear(perform: loadFromPrefs)
        .onChange(of: config) { _, new in
            session.config = new
            PreferencesManager.shared.sessionConfig = new
        }
        .onChange(of: remarksStyle) { _, new in PreferencesManager.shared.remarksStyle = new }
        .onChange(of: launchAtLogin) { _, new in PreferencesManager.shared.launchAtLogin = new }
        .onChange(of: showInMenuBar) { _, new in PreferencesManager.shared.showInMenuBar = new }
        .onChange(of: menuBarOnly) { _, new in PreferencesManager.shared.menuBarOnly = new }
        .onChange(of: telemetryOptIn) { _, new in PreferencesManager.shared.telemetryOptIn = new }
    }

    // MARK: - Exit mechanisms

    @ViewBuilder
    private var exitMechanismsSection: some View {
        Section {
            exitMechanismRow(mechanism: .autoTimer) {
                Picker(
                    String(localized: "settings.timer.duration", comment: "Timer duration picker label"),
                    selection: $config.timerDuration
                ) {
                    ForEach(Self.timerValues, id: \.self) { t in
                        Text(verbatim: "\(Int(t))s").tag(t)
                    }
                }
                .labelsHidden()
                .fixedSize()
            }

            exitMechanismRow(mechanism: .holdKey) {
                Picker(
                    String(localized: "settings.hold_key.duration", comment: "Hold key duration picker label"),
                    selection: $config.holdKeyDuration
                ) {
                    ForEach(Self.holdDurations, id: \.self) { d in
                        Text(verbatim: "\(Int(d))s").tag(d)
                    }
                }
                .labelsHidden()
                .fixedSize()
            }

            exitMechanismRow(mechanism: .keySequence) {
                Picker(
                    String(localized: "settings.key_sequence.count", comment: "Key sequence count picker label"),
                    selection: $config.keySequenceCount
                ) {
                    ForEach(Self.sequenceCounts, id: \.self) { n in
                        Text("Esc × \(n)").tag(n)
                    }
                }
                .labelsHidden()
                .fixedSize()
                .disabled(!config.enabledExitMechanisms.contains(.keySequence))
            }

            exitMechanismRow(mechanism: .touchID) { EmptyView() }

            HStack {
                Label {
                    Text(ExitMechanism.menuBar.title)
                } icon: {
                    Image(systemName: ExitMechanism.menuBar.sfSymbol)
                        .frame(width: 20)
                }
                Spacer()
                Text("settings.always_on", comment: "Label for a mechanism that can't be disabled")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        } header: {
            Text("settings.section.exit_mechanisms", comment: "Exit mechanisms section header")
        } footer: {
            if config.enabledExitMechanisms.isEmpty {
                Text("settings.exit_mechanisms.warning", comment: "Warning when no mechanism is enabled")
                    .foregroundStyle(.red)
            }
        }
    }

    @ViewBuilder
    private func exitMechanismRow<Trailing: View>(
        mechanism: ExitMechanism,
        @ViewBuilder trailing: () -> Trailing = { EmptyView() }
    ) -> some View {
        let isEnabled = Binding<Bool>(
            get: { config.enabledExitMechanisms.contains(mechanism) },
            set: { enabled in
                if enabled {
                    config.enabledExitMechanisms.insert(mechanism)
                } else {
                    config.enabledExitMechanisms.remove(mechanism)
                }
            }
        )
        HStack {
            Toggle(isOn: isEnabled) {
                Label {
                    Text(mechanism.title)
                } icon: {
                    Image(systemName: mechanism.sfSymbol)
                        .frame(width: 20)
                }
            }
            trailing()
        }
    }

    // MARK: - Behavior

    private var behaviorSection: some View {
        Section(String(localized: "settings.section.behavior", comment: "Behavior section header")) {
            Toggle(
                String(localized: "settings.launch_at_login", comment: "Launch at login toggle label"),
                isOn: $launchAtLogin
            )
            Toggle(
                String(localized: "settings.show_in_menu_bar", comment: "Show in menu bar toggle label"),
                isOn: $showInMenuBar
            )
            Toggle(
                String(localized: "settings.menu_bar_only", comment: "Menu bar only mode toggle label"),
                isOn: $menuBarOnly
            )
            .disabled(!showInMenuBar)
        }
    }

    // MARK: - Remarks

    private var remarksSection: some View {
        Section(String(localized: "settings.section.remarks", comment: "Remarks section header")) {
            Picker(
                String(localized: "settings.remarks_style", comment: "Remarks style picker label"),
                selection: $remarksStyle
            ) {
                ForEach(PreferencesManager.RemarksStyle.allCases) { style in
                    Text(style.label).tag(style)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    // MARK: - Privacy

    private var privacySection: some View {
        Section(String(localized: "settings.section.privacy", comment: "Privacy section header")) {
            Toggle(
                String(localized: "settings.telemetry_opt_in", comment: "Telemetry opt-in toggle label"),
                isOn: $telemetryOptIn
            )
            Text("settings.telemetry_description", comment: "Short description of what telemetry collects")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - About

    private var aboutSection: some View {
        Section(String(localized: "settings.section.about", comment: "About section header")) {
            LabeledContent(
                String(localized: "settings.version", comment: "Version label"),
                value: appVersion
            )
            LabeledContent(
                String(localized: "settings.license", comment: "License label"),
                value: "MIT"
            )
            Link("wipey.app", destination: URL(string: "https://wipey.app")!)
            Link(
                String(localized: "settings.github", comment: "GitHub link label"),
                destination: URL(string: "https://github.com/jsoyer/Wipey")!
            )
        }
    }

    // MARK: - Helpers

    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }

    private func loadFromPrefs() {
        let prefs = PreferencesManager.shared
        config = prefs.sessionConfig
        remarksStyle = prefs.remarksStyle
        launchAtLogin = prefs.launchAtLogin
        showInMenuBar = prefs.showInMenuBar
        menuBarOnly = prefs.menuBarOnly
        telemetryOptIn = prefs.telemetryOptIn
    }
}
