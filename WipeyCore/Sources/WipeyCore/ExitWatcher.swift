import Foundation
import CoreGraphics

// MARK: - macOS key codes

/// Well-known macOS virtual key codes referenced by ExitWatcher.
private enum KeyCode {
    /// Escape key (virtual key code on all Apple keyboards).
    static let escape: Int64 = 53
}

/// Monitors input events during a session and fires `onUnlock` when an
/// exit condition is met. Works alongside the CGEventTap — events are routed
/// here before being consumed.
///
/// Thread safety: must be called from the main thread only.
/// (MacOSInputBlocker dispatches CGEventTap events to the main queue before calling process().)
public final class ExitWatcher {

    public var onUnlock: (() -> Void)?

    private var config: SessionConfig?

    // Hold key state
    private var holdKeyStartTime: Date?

    // Key sequence state
    private var keySequenceTaps: [Date] = []

    public init() {}

    public func start(config: SessionConfig) {
        self.config = config
        holdKeyStartTime = nil
        keySequenceTaps = []
    }

    public func stop() {
        config = nil
        holdKeyStartTime = nil
        keySequenceTaps = []
    }

    /// Called by the platform input blocker for every intercepted event.
    /// Returns `true` if the event triggered an unlock (the blocker should
    /// still consume the event — never forward it to other apps).
    @discardableResult
    public func process(type: CGEventType, event: CGEvent) -> Bool {
        guard let config else { return false }

        if type == .keyDown {
            let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
            if keyCode == KeyCode.escape {
                if config.isEnabled(.holdKey)     && checkHoldKey(config: config) { return true }
                if config.isEnabled(.keySequence) && checkKeySequence(config: config) { return true }
            }
        }

        if type == .keyUp {
            let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
            if keyCode == KeyCode.escape {
                holdKeyStartTime = nil
            }
        }

        return false
    }

    // MARK: - Hold key

    private func checkHoldKey(config: SessionConfig) -> Bool {
        let now = Date()
        if holdKeyStartTime == nil {
            holdKeyStartTime = now
        }
        guard let start = holdKeyStartTime else { return false }
        if now.timeIntervalSince(start) >= config.holdKeyDuration {
            triggerUnlock()
            return true
        }
        return false
    }

    // MARK: - Key sequence

    private func checkKeySequence(config: SessionConfig) -> Bool {
        let now = Date()
        keySequenceTaps.append(now)
        // Keep only taps within the 2-second window
        keySequenceTaps = keySequenceTaps.filter { now.timeIntervalSince($0) <= 2 }
        if keySequenceTaps.count >= config.keySequenceCount {
            keySequenceTaps = []
            triggerUnlock()
            return true
        }
        return false
    }

    // MARK: - Trigger

    private func triggerUnlock() {
        DispatchQueue.main.async { [weak self] in
            self?.onUnlock?()
        }
    }
}
