import Foundation

/// All supported ways to end a cleaning session.
public enum ExitMechanism: String, Codable, CaseIterable, Identifiable {
    case autoTimer
    case holdKey
    case keySequence
    case touchID
    case menuBar

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .autoTimer:   return String(localized: "exit_mechanism.auto_timer.title", defaultValue: "Auto timer", comment: "Exit mechanism title")
        case .holdKey:     return String(localized: "exit_mechanism.hold_key.title", defaultValue: "Hold key", comment: "Exit mechanism title")
        case .keySequence: return String(localized: "exit_mechanism.key_sequence.title", defaultValue: "Key sequence", comment: "Exit mechanism title")
        case .touchID:     return String(localized: "exit_mechanism.touch_id.title", defaultValue: "Touch ID", comment: "Exit mechanism title")
        case .menuBar:     return String(localized: "exit_mechanism.menu_bar.title", defaultValue: "Menu bar button", comment: "Exit mechanism title")
        }
    }

    public var subtitle: String {
        switch self {
        case .autoTimer:   return String(localized: "exit_mechanism.auto_timer.subtitle", defaultValue: "Unlocks automatically after a set duration", comment: "Exit mechanism subtitle")
        case .holdKey:     return String(localized: "exit_mechanism.hold_key.subtitle", defaultValue: "Hold Esc for a few seconds to unlock", comment: "Exit mechanism subtitle")
        case .keySequence: return String(localized: "exit_mechanism.key_sequence.subtitle", defaultValue: "Press Esc multiple times rapidly", comment: "Exit mechanism subtitle")
        case .touchID:     return String(localized: "exit_mechanism.touch_id.subtitle", defaultValue: "Authenticate with Touch ID or password", comment: "Exit mechanism subtitle")
        case .menuBar:     return String(localized: "exit_mechanism.menu_bar.subtitle", defaultValue: "Always available — click the Wipey icon", comment: "Exit mechanism subtitle")
        }
    }

    public var sfSymbol: String {
        switch self {
        case .autoTimer:   return "timer"
        case .holdKey:     return "keyboard"
        case .keySequence: return "repeat"
        case .touchID:     return "touchid"
        case .menuBar:     return "menubar.rectangle"
        }
    }

    /// Menu bar is always enabled and cannot be toggled off.
    public var isAlwaysEnabled: Bool {
        self == .menuBar
    }
}
