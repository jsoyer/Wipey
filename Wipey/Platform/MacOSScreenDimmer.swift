import AppKit
import WipeyCore

/// macOS implementation of ScreenDimmer using full-screen black NSWindows.
/// Creates one blackout window per display at screenSaver level.
public final class MacOSScreenDimmer: ScreenDimmer {

    public private(set) var isDimmed = false
    private var blackoutWindows: [NSWindow] = []

    public init() {}

    // MARK: - ScreenDimmer

    public func dim(animated: Bool) {
        guard !isDimmed else { return }

        for screen in NSScreen.screens {
            let window = makeBlackoutWindow(for: screen)
            if animated {
                window.alphaValue = 0
                window.orderFrontRegardless()
                NSAnimationContext.runAnimationGroup { ctx in
                    ctx.duration = 0.4
                    window.animator().alphaValue = 1.0
                }
            } else {
                window.orderFrontRegardless()
            }
            blackoutWindows.append(window)
        }

        isDimmed = true
    }

    public func restore(animated: Bool) {
        guard isDimmed else { return }

        let windows = blackoutWindows
        blackoutWindows = []
        isDimmed = false

        if animated {
            NSAnimationContext.runAnimationGroup { ctx in
                ctx.duration = 0.3
                for window in windows {
                    window.animator().alphaValue = 0
                }
            } completionHandler: {
                for window in windows {
                    window.orderOut(nil)
                }
            }
        } else {
            for window in windows {
                window.orderOut(nil)
            }
        }
    }

    // MARK: - Private

    private func makeBlackoutWindow(for screen: NSScreen) -> NSWindow {
        let window = NSWindow(
            contentRect: screen.frame,
            styleMask: .borderless,
            backing: .buffered,
            defer: false,
            screen: screen
        )
        window.backgroundColor = .black
        window.level = .screenSaver
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        window.isOpaque = true
        window.ignoresMouseEvents = true
        window.isReleasedWhenClosed = false
        return window
    }
}
