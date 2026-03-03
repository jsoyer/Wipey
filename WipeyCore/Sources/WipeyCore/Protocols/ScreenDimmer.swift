import Foundation

/// Abstracts platform-specific screen dimming / blackout.
/// macOS: NSWindow at screenSaver level — iOS: UIView overlay — visionOS: passthrough blackout
public protocol ScreenDimmer: AnyObject {

    /// Cover all displays with a black overlay.
    func dim(animated: Bool)

    /// Remove the black overlay and restore normal display.
    func restore(animated: Bool)

    /// Whether the screen is currently blacked out.
    var isDimmed: Bool { get }
}
