import AppKit
import SwiftUI
import LocalAuthentication
import Observation
import ServiceManagement
import WipeyCore

final class AppDelegate: NSObject, NSApplicationDelegate {

    // MARK: - Core objects

    let inputBlocker = MacOSInputBlocker()
    let screenDimmer = MacOSScreenDimmer()

    lazy var sessionManager: SessionManager = {
        let prefs = PreferencesManager.shared
        return SessionManager(
            inputBlocker: inputBlocker,
            screenDimmer: screenDimmer,
            config: prefs.sessionConfig
        )
    }()

    // MARK: - UI

    private var statusItem: NSStatusItem!
    private var sessionHUDWindow: NSWindow?
    private var laContext: LAContext?

    // MARK: - Lifecycle

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupStatusItem()
        NSApp.activate(ignoringOtherApps: true)
        startObservingSession()
        startObservingPreferences()
        // Sync SMAppService with the stored preference on every launch.
        // This recovers from any state drift (e.g. manual toggle in Login Items).
        applyLaunchAtLogin(PreferencesManager.shared.launchAtLogin)
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            NSApp.windows.first(where: { !$0.isFloatingPanel })?.makeKeyAndOrderFront(nil)
        }
        return true
    }

    // MARK: - Status item

    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        guard let button = statusItem.button else { return }
        button.image = NSImage(systemSymbolName: "sparkles", accessibilityDescription: "Wipey")
        button.image?.isTemplate = true
        button.target = self
        button.action = #selector(statusItemClicked(_:))
        button.sendAction(on: [.leftMouseUp, .rightMouseUp])
    }

    @objc private func statusItemClicked(_ sender: NSStatusBarButton) {
        guard let event = NSApp.currentEvent else { return }
        if event.type == .rightMouseUp {
            showContextMenu()
        } else {
            openMainWindow()
        }
    }

    private func showContextMenu() {
        let menu = NSMenu()

        if sessionManager.state.isActive {
            let stop = NSMenuItem(
                title: String(localized: "menu.stop_cleaning", comment: "Menu item to stop an active session"),
                action: #selector(stopCleaning),
                keyEquivalent: ""
            )
            stop.target = self
            menu.addItem(stop)
        } else {
            let start = NSMenuItem(
                title: String(localized: "menu.start_cleaning", comment: "Menu item to start a session"),
                action: #selector(startCleaning),
                keyEquivalent: ""
            )
            start.target = self
            menu.addItem(start)
        }

        menu.addItem(.separator())

        let open = NSMenuItem(
            title: String(localized: "menu.open_wipey", comment: "Menu item to open the main window"),
            action: #selector(openMainWindow),
            keyEquivalent: ""
        )
        open.target = self
        menu.addItem(open)

        let settings = NSMenuItem(
            title: String(localized: "menu.settings", comment: "Menu item to open Settings"),
            action: #selector(openSettings),
            keyEquivalent: ","
        )
        settings.target = self
        menu.addItem(settings)

        menu.addItem(.separator())

        let quit = NSMenuItem(
            title: String(localized: "menu.quit", comment: "Menu item to quit the app"),
            action: #selector(NSApplication.terminate(_:)),
            keyEquivalent: "q"
        )
        menu.addItem(quit)

        statusItem.menu = menu
        statusItem.button?.performClick(nil)
        statusItem.menu = nil
    }

    @objc private func openMainWindow() {
        NSApp.activate(ignoringOtherApps: true)
        NSApp.windows.first(where: { !($0 is NSPanel) })?.makeKeyAndOrderFront(nil)
    }

    @objc private func startCleaning() {
        try? sessionManager.startSession()
    }

    @objc private func stopCleaning() {
        sessionManager.endSession()
    }

    @objc private func openSettings() {
        NSApp.activate(ignoringOtherApps: true)
        NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
    }

    // MARK: - Preferences observation

    private func startObservingPreferences() {
        withObservationTracking {
            _ = PreferencesManager.shared.launchAtLogin
        } onChange: { [weak self] in
            Task { @MainActor in
                self?.applyLaunchAtLogin(PreferencesManager.shared.launchAtLogin)
                self?.startObservingPreferences()
            }
        }
    }

    private func applyLaunchAtLogin(_ enabled: Bool) {
        do {
            if enabled {
                if SMAppService.mainApp.status != .enabled {
                    try SMAppService.mainApp.register()
                }
            } else {
                if SMAppService.mainApp.status == .enabled {
                    try SMAppService.mainApp.unregister()
                }
            }
        } catch {
            // Registration can legitimately fail if the app is not in /Applications.
            // This is expected during development — the preference is still persisted
            // and re-applied on next launch from the correct location.
        }
    }

    // MARK: - Session observation

    private func startObservingSession() {
        withObservationTracking {
            _ = sessionManager.state
        } onChange: { [weak self] in
            Task { @MainActor in
                self?.handleSessionStateChange()
                self?.startObservingSession()
            }
        }
    }

    @MainActor
    private func handleSessionStateChange() {
        switch sessionManager.state {
        case .active:
            showSessionHUD()
            initiateLocalAuthIfNeeded()
        case .idle:
            closeSessionHUD()
            cancelLocalAuth()
        default:
            break
        }
    }

    // MARK: - Session HUD

    @MainActor
    private func showSessionHUD() {
        closeSessionHUD()

        let hosting = NSHostingView(rootView: hudContent())

        let window = NSPanel(
            contentRect: hudFrame(compact: !sessionManager.config.blackoutScreen),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        window.contentView = hosting
        window.backgroundColor = .clear
        window.isOpaque = false
        window.level = NSWindow.Level(rawValue: NSWindow.Level.screenSaver.rawValue + 1)
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        window.ignoresMouseEvents = true
        window.orderFrontRegardless()

        sessionHUDWindow = window
    }

    @ViewBuilder @MainActor
    private func hudContent() -> some View {
        if sessionManager.config.blackoutScreen {
            SessionView().environment(sessionManager)
        } else {
            HUDView().environment(sessionManager)
        }
    }

    private func closeSessionHUD() {
        sessionHUDWindow?.orderOut(nil)
        sessionHUDWindow = nil
    }

    private func hudFrame(compact: Bool) -> CGRect {
        guard let screen = NSScreen.main else { return .zero }
        if compact {
            let w: CGFloat = 240
            let h: CGFloat = 72
            return CGRect(
                x: screen.visibleFrame.maxX - w - 16,
                y: screen.visibleFrame.minY + 16,
                width: w,
                height: h
            )
        } else {
            return CGRect(
                x: screen.frame.midX - 190,
                y: screen.frame.midY - 200,
                width: 380,
                height: 400
            )
        }
    }

    // MARK: - Touch ID

    private func initiateLocalAuthIfNeeded() {
        guard sessionManager.config.isEnabled(.touchID) else { return }
        let context = LAContext()
        laContext = context
        let reason = String(localized: "auth.reason", comment: "Touch ID / password prompt reason")
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { [weak self] success, _ in
            guard success else { return }
            DispatchQueue.main.async {
                self?.sessionManager.endSession()
            }
        }
    }

    private func cancelLocalAuth() {
        laContext?.invalidate()
        laContext = nil
    }
}

// MARK: - NSWindow convenience

private extension NSWindow {
    var isFloatingPanel: Bool { self is NSPanel }
}
