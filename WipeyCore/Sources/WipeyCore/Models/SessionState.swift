import Foundation

/// The lifecycle state of a Wipey cleaning session.
public enum SessionState: Equatable {
    case idle
    case starting
    case active(startedAt: Date)
    case ending

    public var isActive: Bool {
        if case .active = self { return true }
        return false
    }

    public var startDate: Date? {
        if case .active(let date) = self { return date }
        return nil
    }
}
