import AppKit
import CoreGraphics
import WipeyCore

/// macOS implementation of InputBlocker using CGEventTap.
/// Requires Accessibility permission (AXIsProcessTrusted()).
/// The event tap intercepts all input at the session level before any app receives it.
///
/// Thread safety: the CGEventTap callback fires on the system event-tap thread.
/// All ExitWatcher access is dispatched to the main queue to avoid data races.
public final class MacOSInputBlocker: InputBlocker {

    public private(set) var isBlocking = false
    public var exitWatcher: ExitWatcher?

    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?

    public init() {}

    deinit {
        // Guarantee the tap is disabled before this object is deallocated.
        // Without this, the system could invoke the C callback with a dangling userInfo pointer.
        stopBlocking()
    }

    // MARK: - InputBlocker

    public func startBlocking(config: SessionConfig) throws {
        guard AXIsProcessTrusted() else {
            throw InputBlockerError.accessibilityPermissionDenied
        }

        let mask = blockedEventTypes.reduce(CGEventMask(0)) { acc, type in
            acc | (CGEventMask(1) << type.rawValue)
        }

        guard let tap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: mask,
            callback: wipeyEventTapCallback,
            userInfo: Unmanaged.passUnretained(self).toOpaque()
        ) else {
            throw InputBlockerError.tapCreationFailed
        }

        let source = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
        CFRunLoopAddSource(CFRunLoopGetMain(), source, .commonModes)
        CGEvent.tapEnable(tap: tap, enable: true)

        eventTap = tap
        runLoopSource = source
        isBlocking = true
    }

    public func stopBlocking() {
        if let tap = eventTap {
            CGEvent.tapEnable(tap: tap, enable: false)
        }
        if let source = runLoopSource {
            CFRunLoopRemoveSource(CFRunLoopGetMain(), source, .commonModes)
        }
        eventTap = nil
        runLoopSource = nil
        isBlocking = false
    }
}

// MARK: - Blocked event types

private let blockedEventTypes: [CGEventType] = [
    .keyDown, .keyUp, .flagsChanged,
    .leftMouseDown, .leftMouseUp,
    .rightMouseDown, .rightMouseUp,
    .mouseMoved, .leftMouseDragged, .rightMouseDragged,
    .scrollWheel, .otherMouseDown, .otherMouseUp,
    .tabletPointer, .tabletProximity,
]

// MARK: - C callback (no captures — uses userInfo to reach the blocker)
//
// This function runs on the system CGEventTap thread, NOT the main thread.
// ExitWatcher state mutations are dispatched to the main queue for thread safety.

private func wipeyEventTapCallback(
    proxy: CGEventTapProxy,
    type: CGEventType,
    event: CGEvent,
    userInfo: UnsafeMutableRawPointer?
) -> Unmanaged<CGEvent>? {
    guard let userInfo else { return Unmanaged.passRetained(event) }
    let blocker = Unmanaged<MacOSInputBlocker>.fromOpaque(userInfo).takeUnretainedValue()

    // Dispatch ExitWatcher processing to the main thread.
    // The event is already consumed (nil return) — this dispatch only decides whether to unlock.
    if let watcher = blocker.exitWatcher {
        DispatchQueue.main.async {
            watcher.process(type: type, event: event)
        }
    }

    return nil // consume / block the event regardless
}
