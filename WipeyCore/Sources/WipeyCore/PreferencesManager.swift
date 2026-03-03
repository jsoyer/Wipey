import Foundation

/// Persists user preferences using UserDefaults.
/// All access to UserDefaults is centralised here — never call UserDefaults directly.
@Observable
public final class PreferencesManager {

    public static let shared = PreferencesManager()

    private let defaults = UserDefaults.standard

    // MARK: - Keys

    private enum Key: String {
        case sessionConfig
        case remarksStyle
        case launchAtLogin
        case showInMenuBar
        case menuBarOnly
        case telemetryOptIn
        case hasCompletedOnboarding
    }

    // MARK: - Session config

    public var sessionConfig: SessionConfig {
        get {
            guard let data = defaults.data(forKey: Key.sessionConfig.rawValue),
                  let config = try? JSONDecoder().decode(SessionConfig.self, from: data)
            else { return SessionConfig() }
            return config
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            defaults.set(data, forKey: Key.sessionConfig.rawValue)
        }
    }

    // MARK: - Remarks

    public enum RemarksStyle: String, CaseIterable, Identifiable, Codable {
        case sarcastic
        case zen
        case silent

        public var id: String { rawValue }

        public var label: String {
            switch self {
            case .sarcastic: return "Sarcastic"
            case .zen:       return "Zen"
            case .silent:    return "Silent"
            }
        }
    }

    public var remarksStyle: RemarksStyle {
        get {
            let raw = defaults.string(forKey: Key.remarksStyle.rawValue) ?? ""
            return RemarksStyle(rawValue: raw) ?? .sarcastic
        }
        set { defaults.set(newValue.rawValue, forKey: Key.remarksStyle.rawValue) }
    }

    // MARK: - Behaviour

    public var launchAtLogin: Bool {
        get { defaults.bool(forKey: Key.launchAtLogin.rawValue) }
        set { defaults.set(newValue, forKey: Key.launchAtLogin.rawValue) }
    }

    public var showInMenuBar: Bool {
        get { defaults.object(forKey: Key.showInMenuBar.rawValue) as? Bool ?? true }
        set { defaults.set(newValue, forKey: Key.showInMenuBar.rawValue) }
    }

    public var menuBarOnly: Bool {
        get { defaults.bool(forKey: Key.menuBarOnly.rawValue) }
        set { defaults.set(newValue, forKey: Key.menuBarOnly.rawValue) }
    }

    // MARK: - Privacy

    public var telemetryOptIn: Bool {
        get { defaults.bool(forKey: Key.telemetryOptIn.rawValue) }
        set { defaults.set(newValue, forKey: Key.telemetryOptIn.rawValue) }
    }

    // MARK: - Onboarding

    public var hasCompletedOnboarding: Bool {
        get { defaults.bool(forKey: Key.hasCompletedOnboarding.rawValue) }
        set { defaults.set(newValue, forKey: Key.hasCompletedOnboarding.rawValue) }
    }

    private init() {}
}
