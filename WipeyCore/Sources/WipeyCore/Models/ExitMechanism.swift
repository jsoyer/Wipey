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
        case .autoTimer:   return "Auto timer"
        case .holdKey:     return "Hold key"
        case .keySequence: return "Key sequence"
        case .touchID:     return "Touch ID"
        case .menuBar:     return "Menu bar button"
        }
    }

    public var subtitle: String {
        switch self {
        case .autoTimer:   return "Unlocks automatically after a set duration"
        case .holdKey:     return "Hold Esc for a few seconds to unlock"
        case .keySequence: return "Press Esc multiple times rapidly"
        case .touchID:     return "Authenticate with Touch ID or password"
        case .menuBar:     return "Always available — click the Wipey icon"
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
