import Foundation

/// All configuration options for a single cleaning session.
public struct SessionConfig: Codable, Equatable {

    // MARK: - What to lock
    public var lockKeyboard: Bool
    public var lockTrackpad: Bool
    public var blackoutScreen: Bool

    // MARK: - Exit mechanisms
    public var enabledExitMechanisms: Set<ExitMechanism>
    public var timerDuration: TimeInterval       // seconds, used by .autoTimer
    public var holdKeyDuration: TimeInterval     // seconds, used by .holdKey
    public var keySequenceCount: Int             // taps, used by .keySequence

    // MARK: - Defaults
    public init(
        lockKeyboard: Bool = true,
        lockTrackpad: Bool = true,
        blackoutScreen: Bool = true,
        enabledExitMechanisms: Set<ExitMechanism> = [.autoTimer, .holdKey, .touchID, .menuBar],
        timerDuration: TimeInterval = 60,
        holdKeyDuration: TimeInterval = 3,
        keySequenceCount: Int = 5
    ) {
        self.lockKeyboard = lockKeyboard
        self.lockTrackpad = lockTrackpad
        self.blackoutScreen = blackoutScreen
        self.enabledExitMechanisms = enabledExitMechanisms
        self.timerDuration = timerDuration
        self.holdKeyDuration = holdKeyDuration
        self.keySequenceCount = keySequenceCount
    }

    /// Returns true if at least one exit mechanism is active.
    public var hasValidExitMechanism: Bool {
        !enabledExitMechanisms.isEmpty
    }

    public func isEnabled(_ mechanism: ExitMechanism) -> Bool {
        mechanism.isAlwaysEnabled || enabledExitMechanisms.contains(mechanism)
    }
}
