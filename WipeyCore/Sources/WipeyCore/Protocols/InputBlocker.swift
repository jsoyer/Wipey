import Foundation

/// Abstracts platform-specific input blocking (keyboard, trackpad, mouse).
/// macOS: CGEventTap — iOS: UIWindow overlay — visionOS: gesture suppression
public protocol InputBlocker: AnyObject {

    /// Start blocking input according to the session configuration.
    /// Throws `InputBlockerError` if the system denies the request.
    func startBlocking(config: SessionConfig) throws

    /// Stop blocking input and restore normal system behaviour.
    func stopBlocking()

    /// Whether input is currently being blocked.
    var isBlocking: Bool { get }
}

public enum InputBlockerError: LocalizedError {
    case accessibilityPermissionDenied
    case tapCreationFailed
    case unsupportedPlatform

    public var errorDescription: String? {
        switch self {
        case .accessibilityPermissionDenied:
            return "Wipey needs Accessibility permission to lock your keyboard and trackpad."
        case .tapCreationFailed:
            return "Could not create the input tap. Please try restarting Wipey."
        case .unsupportedPlatform:
            return "This platform does not support input blocking."
        }
    }
}
